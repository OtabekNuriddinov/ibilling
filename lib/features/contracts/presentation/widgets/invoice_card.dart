import 'package:ibilling/features/contracts/presentation/widgets/invoice_card_row.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';
import '../barrel.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final int displayIndex;
  const InvoiceCard({super.key, required this.invoice, required this.displayIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(6),
      ),
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
                  invoice.statusLabel,
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
          /// InvoiceCardRow qil
          SizedBox(height: 1.h),
          InvoiceCardRow(
            invoice: invoice,
            startWord: 'Service',
            endWord: invoice.serviceName,
          ),
          SizedBox(height: 1.h),
          InvoiceCardRow(
            invoice: invoice,
            startWord: 'Amount',
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
    );
  }
}


