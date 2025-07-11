import 'contracts_row.dart';
import '../barrel.dart';
import 'package:easy_localization/easy_localization.dart';

class ContractCard extends StatelessWidget {
  final ContractModel contract;
  final int displayIndex;
  final VoidCallback onPressed;
  const ContractCard({super.key, required this.contract, required this.displayIndex, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Material(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(6),
        child:  InkWell(
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
                          color: CommonMethods.getStatusColorUniversal(contract.status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          CommonMethods.statusLabelToKey(contract.statusLabel).tr(),
                          style: TextStyle(
                            color: CommonMethods.getStatusColorUniversal(contract.status),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Ubuntu',
                            fontSize: 14.5.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ContractCardRow(
                    contract: contract,
                    startWord: "fish".tr(),
                    endWord: contract.fullName,
                  ),
                  SizedBox(height: 1.h),
                  ContractCardRow(
                    contract: contract,
                    startWord: "amount".tr(),
                    endWord: "${contract.amount} USZ",
                  ),
                  SizedBox(height: 1.h),
                  ContractCardRow(
                    contract: contract,
                    startWord: "last_invoice".tr(),
                    endWord: "№ ${contract.lastInvoiceNumber}",
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        'number_of_invoices'.tr(),
                        style: AppTextStyles.cardTextStyle.copyWith(
                          color: AppColors.white2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${contract.numberOfInvoices}',
                        style: AppTextStyles.cardTextStyle.copyWith(
                          color: AppColors.white.withAlpha(100),
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${contract.date.day.toString().padLeft(2, '0')}.${contract.date.month.toString().padLeft(2, '0')}.${contract.date.year}',
                        style: AppTextStyles.tableCalendarDateStyle.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.white.withAlpha(100),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


