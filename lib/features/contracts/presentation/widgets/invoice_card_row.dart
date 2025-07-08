import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';
import 'package:easy_localization/easy_localization.dart';

class InvoiceCardRow extends StatelessWidget {
  final InvoiceModel invoice;
  final String startWord;
  final String endWord;
  const InvoiceCardRow({
    super.key,
    required this.invoice,
    required this.startWord,
    required this.endWord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$startWord:".tr(),
          style: AppTextStyles.cardTextStyle.copyWith(fontSize: 15.5.sp),
        ),
        const SizedBox(width: 8),
        Text(
          endWord,
          style: AppTextStyles.cardTextStyle.copyWith(
            color: AppColors.white.withAlpha(100),
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
