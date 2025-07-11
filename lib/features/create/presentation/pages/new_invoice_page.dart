import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/core/common/validation.dart';
import '../barrel.dart';

class NewInvoicePage extends StatefulWidget {
  const NewInvoicePage({super.key});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final serviceController = TextEditingController();
  final summaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode serviceFocus = FocusNode();
  final FocusNode summaFocus = FocusNode();
  String? status;

  @override
  void dispose() {
    serviceController.dispose();
    summaController.dispose();
    serviceFocus.dispose();
    summaFocus.dispose();
    super.dispose();
  }

  final List<String> statuses = [
    'paid'.tr(),
    'in_process'.tr(),
    'rejected_by_payme'.tr(),
    'rejected_by_iq'.tr(),
  ];



  void validateAndSave() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (status == null) {
      AppSnackBar.showSnackBar(context, "please_select_all_fields".tr());
      return;
    }
    if (valid) {
      final englishStatus = CommonMethods.statusLabelToEnglish(status!);
      final invoice = InvoiceEntity(
        id: null,
        serviceName: serviceController.text,
        amount: "1,200,000",
        status: CommonMethods.statusFromLabelUniversal(
          englishStatus,
          CommonMethods.invoiceStatusMap,
          InvoiceStatus.inProcess,
        ),
        statusLabel: englishStatus,
        date: DateTime.now(),
      );

      context.read<InvoiceBloc>().add(AddInvoiceEvent(invoice));
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
            Text("new_invoice".tr(), style: AppTextStyles.appbarTextStyle),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "service_name".tr(),
                style: AppTextStyles.aboveTextFieldStyle,
              ),
              SizedBox(height: 0.5.h),
              CustomTextField(
                controller: serviceController,
                focusNode: serviceFocus,
                validator: Validation.validateService,
              ),
              const SizedBox(height: 16),
              Text(
                "invoice_amount".tr(),
                style: AppTextStyles.aboveTextFieldStyle,
              ),
              SizedBox(height: 0.5.h),
              CustomTextField(
                controller: summaController,
                focusNode: summaFocus,
                validator: Validation.validateAmount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                "status_of_the_invoice".tr(),
                style: AppTextStyles.aboveTextFieldStyle,
              ),
              SizedBox(height: 0.5.h),
              CustomDropDownField(
                value: status == null ? null : status,
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
                    'save_invoice'.tr(),
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
    );
  }
}
