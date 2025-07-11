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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
             Text(
                "date".tr(),
                style: AppTextStyles.filterAboveTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700
                ),
              ),
            const SizedBox(height: 10),
             Row(
                children: [
                  DateSelectable(
                      label: 'from'.tr(),
                      date: fromDate,
                      onPressed: () => _selectDate(context, true),
                    ),

                  const SizedBox(width: 16),
                  Text(
                    '-',
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 26.sp,
                    ),
                  ),
                  const SizedBox(width: 16),
                   DateSelectable(
                      label: 'to'.tr(),
                      date: toDate,
                      onPressed: () => _selectDate(context, false),
                    ),

                ],
              ),

            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ContractBloc, ContractState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(
                      child: Text('${"error".tr()}: ${state.error}'),
                    );
                  }
                  final filteredContracts = FilterMethods.applyFilters(
                    allContracts: state.contracts.map((e) => ContractModel.fromEntity(e)).toList(),
                    paid: false,
                    rejectedByIQ: false,
                    inProcess: false,
                    rejectedByPayme: false,
                    fromDate: fromDate,
                    toDate: toDate,
                  );
                  if(fromDate == null && toDate == null){
                    return Center(
                      child: NoMadeWidget(
                        text: "no_history_for_this_period".tr(),
                        iconUrl: AppIcons.documentIcon,
                      ),
                    );
                  }
                  if (filteredContracts.isEmpty) {
                    return Center(
                      child: NoMadeWidget(
                        text: "no_history_for_this_period".tr(),
                        iconUrl: AppIcons.documentIcon,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredContracts.length,
                    itemBuilder: (context, index) {
                      final contract = filteredContracts[index];
                      return ContractCard(
                        contract: ContractModel.fromEntity(contract),
                        displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
                        onPressed: () {
                          context.go(
                            "/history/history_contract_details",
                            extra: {
                              "contract": contract,
                              "displayIndex":
                                  int.tryParse(contract.id ?? '0') ?? 0,
                            },
                          );
                        },
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
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    if(isFrom){
      if(toDate != null){
        lastDate = toDate!;
      }
      if(fromDate != null){
        initialDate = fromDate!;
      }
    }
    else{
      if(fromDate != null){
         firstDate = fromDate!;
         initialDate = fromDate!;
      }
      if(toDate != null){
        initialDate = toDate!;
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.darkGreen,
              onPrimary: Colors.white,
              surface: AppColors.darkest,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          if(toDate != null && picked.isAfter(toDate!)){
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }
}
