import 'package:ibilling/features/contracts/presentation/barrel.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods.customAppBar(
        backColor: AppColors.darkest,
        context: context,
        filterPressed: () {
          context.go('/contracts/filter');
        },
        iconPressed: () {
          context.go('/contracts/search');
        },
        title: "history".tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text("date".tr(), style: AppTextStyles.filterAboveTextStyle),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(right: 15.w, left: 1.5.w),
              child: Row(
                children: [
                  Expanded(
                    child: DateSelectable(
                      label: 'from'.tr(),
                      date: fromDate,
                      onPressed: () => _selectDate(context, true),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '-',
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: DateSelectable(
                      label: 'to'.tr(),
                      date: toDate,
                      onPressed: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: BlocBuilder<ContractBloc, ContractState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text('${"error".tr()}: ${state.error}'));
                  }
                  if(fromDate==null || toDate == null){
                    return SizedBox.shrink();
                  }
                  final filteredContracts = state.contracts.where((contract) {
                    final contractDate = contract.date;
                    if (fromDate != null && contractDate.isBefore(fromDate!)) {
                      return false;
                    }
                    if (toDate != null && contractDate.isAfter(toDate!)) {
                      return false;
                    }
                    return true;
                  }).toList();
                  if (filteredContracts.isEmpty) {
                    return Center(
                      child: NoMadeWidget(
                        text: "no_history_for_this_period".tr(),
                        iconUrl: AppIcons.documentIcon,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: filteredContracts.length,
                    itemBuilder: (context, index) {
                      final contract = filteredContracts[index];
                      return Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: (){
                            context.go("/history/history_contract_details", extra: {
                              "contract": contract,
                              "displayIndex": int.tryParse(contract.id ?? '0') ?? 0,
                            });
                          },
                          child: ContractCard(
                            contract: ContractModel.fromEntity(contract),
                            displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }
}
