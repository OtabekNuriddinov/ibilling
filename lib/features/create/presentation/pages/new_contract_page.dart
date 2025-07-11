import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/core/common/validation.dart';
import '../barrel.dart';

import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

class NewContractPage extends StatefulWidget {
  const NewContractPage({super.key});

  @override
  State<NewContractPage> createState() => _NewContractPageState();
}

class _NewContractPageState extends State<NewContractPage> {
  String? personType;
  String? status;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final innController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FocusNode nameFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode innFocus = FocusNode();

  bool innHasError = false;

  final List<String> personTypes = ['physical'.tr(), 'legal'.tr()];

  final List<String> statuses = [
    'paid'.tr(),
    'in_process'.tr(),
    'rejected_by_payme'.tr(),
    'rejected_by_iq'.tr(),
  ];

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    innController.dispose();
    nameFocus.dispose();
    addressFocus.dispose();
    innFocus.dispose();
    super.dispose();
  }

  void validateAndSave() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    setState(() {
      innHasError = Validation.validateInn(innController.text) != null;
    });
    if (personType == null || status == null) {
      AppSnackBar.showSnackBar(context, "please_select_all_fields".tr());
      return;
    }
    if (valid) {
      final englishStatus = CommonMethods.statusLabelToEnglish(status!);
      final contract = ContractEntity(
        id: null,
        personType: personType!,
        fullName: nameController.text,
        address: addressController.text,
        inn: innController.text,
        amount: "1,200,00",
        lastInvoiceNumber: 156,
        numberOfInvoices: 10,
        date: DateTime.now(),
        status: CommonMethods.statusFromLabelUniversal(
          englishStatus,
          CommonMethods.contractStatusMap,
          ContractStatus.inProcess,
        ),
        statusLabel: englishStatus,
      );
      context.read<ContractBloc>().add(AddContractEvent(contract));
      context.go('/contracts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkest,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.appBarIcon),
            SizedBox(width: 2.5.w),
            Text("new_contract".tr(), style: AppTextStyles.appbarTextStyle),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocListener<ContractBloc, ContractState>(
        listener: (context, state) {
          if (state.status == ContractListStatus.success && state.lastAction == ContractAction.add) {
            AppSnackBar.showSnackBar(context, "contract_successfully_added".tr());
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                context.go('/contracts');
              }
            });
          } else if (state.status == ContractListStatus.success && state.lastAction == ContractAction.delete) {
            AppSnackBar.showSnackBar(context, "contract_successfully_deleted".tr());
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                context.go('/contracts');
              }
            });
          } else if (state.error != null) {
            AppSnackBar.showSnackBar(context, state.error!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "individual".tr(),
                  style: AppTextStyles.aboveTextFieldStyle,
                ),
                SizedBox(height: 0.5.h),
                CustomDropDownField(
                  value: personType == null ? null : personType,
                  items: personTypes.map((e) => e.tr()).toList(),
                  hint: "select_person_type".tr(),
                  onChanged: (v) => setState(
                    () => personType =
                        personTypes[personTypes
                            .map((e) => e.tr())
                            .toList()
                            .indexOf(v!)],
                  ),
                ),
                const SizedBox(height: 16),

                // Fisher's full name
                Text(
                  "fishers_full_name".tr(),
                  style: AppTextStyles.aboveTextFieldStyle,
                ),
                SizedBox(height: 0.5.h),
                CustomTextField(
                  controller: nameController,
                  focusNode: nameFocus,
                  validator: Validation.validateName,
                ),
                const SizedBox(height: 16),

                Text("address".tr(), style: AppTextStyles.aboveTextFieldStyle),
                SizedBox(height: 0.5.h),
                CustomTextField(
                  controller: addressController,
                  focusNode: addressFocus,
                  validator: Validation.validateAddress,
                ),
                const SizedBox(height: 16),
                Text("tin".tr(), style: AppTextStyles.aboveTextFieldStyle),
                SizedBox(height: 0.5.h),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: innController,
                      focusNode: innFocus,
                      keyboardType: TextInputType.number,
                      validator: Validation.validateInn,
                    ),
                    if (!innHasError)
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            // Info tap action
                          },
                          child: Tooltip(
                            message: 'Info',
                            child: SvgPicture.asset(
                              "assets/icons/help_circle.svg",
                              height: 22,
                              width: 22,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                Text("status".tr(), style: AppTextStyles.aboveTextFieldStyle),
                SizedBox(height: 0.5.h),
                CustomDropDownField(
                  value: status,
                  items: statuses.map((e) => e.tr()).toList(),
                  hint: "select_status".tr(),
                  onChanged: (v) => setState(
                    () => status =
                        statuses[statuses
                            .map((e) => e.tr())
                            .toList()
                            .indexOf(v!)],
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: validateAndSave,
                    child: Text(
                      'save_contract'.tr(),
                      style: AppTextStyles.cardTextStyle.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
