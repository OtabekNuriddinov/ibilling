import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/features/contracts/presentation/widgets/custom_calendar.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/presentation/bloc/contract_bloc.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final List<String> personTypes = [
    'physical'.tr(),
    'legal'.tr(),
  ];

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
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
              onChanged: (v) => setState(() => personType = personTypes[personTypes.map((e) => e.tr()).toList().indexOf(v!)]),
            ),
            const SizedBox(height: 16),

            // Fisher's full name
            Text(
              "fishers_full_name".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
            ),
            SizedBox(height: 0.5.h),
            CustomTextField(controller: nameController),
            const SizedBox(height: 16),

            Text(
              "address".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
            ),
            SizedBox(height: 0.5.h),
            CustomTextField(controller: addressController, maxLines: 2),
            const SizedBox(height: 16),
            Text(
              "tin".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
            ),
            SizedBox(height: 0.5.h),
            CustomTextField(
              controller: innController,
              keyboardType: TextInputType.number,
              hasInfo: true,
            ),
            const SizedBox(height: 16),
            Text(
              "status".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
            ),
            SizedBox(height: 0.5.h),
            CustomDropDownField(
              value: status,
              items: statuses.map((e) => e.tr()).toList(),
              hint: "select_status".tr(),
              onChanged: (v) => setState(() => status = statuses[statuses.map((e) => e.tr()).toList().indexOf(v!)]),
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
                onPressed: () async {
                  if (personType == null || status == null) {
                    AppSnackBar.showSnackBar(context, "please_select_all_fields".tr());
                    return;
                  }
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
                      status!,
                      CommonMethods.contractStatusMap,
                      ContractStatus.inProcess,
                    ),
                    statusLabel: status!,
                  );
                  context.read<ContractBloc>().add(AddContractEvent(contract));
                  AppSnackBar.showSnackBar(context, "contract_successfully_added".tr());
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (mounted) {
                      context.go('/contracts');
                    }
                  });
                },
                child: Text(
                  'save_contract'.tr(),
                  style: AppTextStyles.cardTextStyle.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



