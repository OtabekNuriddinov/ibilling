import 'package:easy_localization/easy_localization.dart';

import '../barrel.dart';

class NewInvoicePage extends StatefulWidget {
  const NewInvoicePage({super.key});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {

  final serviceController = TextEditingController();
  final summaController = TextEditingController();

  final List<String> statuses = [
    'paid'.tr(),
    'in_process'.tr(),
    'rejected_by_payme'.tr(),
    'rejected_by_iq'.tr(),
  ];

  String? status;

  @override
  void dispose() {
    serviceController.dispose();
    summaController.dispose();
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
            Text("new_invoice".tr(), style: AppTextStyles.appbarTextStyle),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "service_name".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
            ),
            SizedBox(height: 0.5.h),
            CustomTextField(controller: serviceController),
            const SizedBox(height: 16),
            Text(
              "invoice_amount".tr(),
              style: AppTextStyles.aboveTextFieldStyle,
              ),
            SizedBox(height: 0.5.h),
            CustomTextField(controller: summaController),
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
                  final invoice = InvoiceEntity(
                    id: null,
                    serviceName: serviceController.text,
                    amount: summaController.text,
                    status: CommonMethods.statusFromLabelUniversal(
                      status!,
                      CommonMethods.invoiceStatusMap,
                      InvoiceStatus.inProcess,
                    ),
                    statusLabel: status!,
                    date: DateTime.now(),
                  );
                  context.read<InvoiceBloc>().add(AddInvoiceEvent(invoice));
                  AppSnackBar.showSnackBar(context, "invoice_successfully_added".tr());
                  Future.delayed(Duration(milliseconds: 500), () {
                    context.go('/contracts');
                  });
                },
                child: Text(
                  'save_invoice'.tr(),
                  style: AppTextStyles.cardTextStyle.copyWith(
                    fontSize: 16.sp,
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

