import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/features/contracts/presentation/widgets/invoice_card_row.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';
import '../barrel.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final int displayIndex;
  final VoidCallback onPressed;
  const InvoiceCard({super.key, required this.invoice, required this.displayIndex, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Material(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppIcons.paperIcon, width: 2.w, height: 3.h),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '№ $displayIndex',
                        style: AppTextStyles.numberTextStyle.copyWith(
                          color: AppColors.white2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CommonMethods.getStatusColorUniversal(invoice.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        CommonMethods.statusLabelToKey(invoice.statusLabel).tr(),
                        style: TextStyle(
                          color: CommonMethods.getStatusColorUniversal(invoice.status),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Ubuntu',
                          fontSize: 14.5.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(height: 1.h),
                InvoiceCardRow(
                  invoice: invoice,
                  startWord: 'service'.tr(),
                  endWord: invoice.serviceName,
                ),
                SizedBox(height: 1.h),
                InvoiceCardRow(
                  invoice: invoice,
                  startWord: 'amount'.tr(),
                  endWord: "${CommonMethods.formatAmount(invoice.amount)} UZS",
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '${invoice.date.day.toString().padLeft(2, '0')}.${invoice.date.month.toString().padLeft(2, '0')}.${invoice.date.year}',
                      style: AppTextStyles.tableCalendarDateStyle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white.withAlpha(100),
                      )
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


