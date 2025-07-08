import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:easy_localization/easy_localization.dart';

class ContractCardRow extends StatelessWidget {
  final ContractModel contract;
  final String startWord;
  final String endWord;
  const ContractCardRow({
    super.key,
    required this.contract,
    required this.startWord,
    required this.endWord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$startWord:".tr(), style: AppTextStyles.cardTextStyle.copyWith(
          fontSize: 15.5.sp,
        ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            endWord,
            maxLines: 5,
            overflow: TextOverflow.visible,
            softWrap: true,
            style: AppTextStyles.cardTextStyle.copyWith(
              color: AppColors.white.withAlpha(100),
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}