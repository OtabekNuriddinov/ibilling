import 'package:ibilling/features/contracts/presentation/widgets/no_made_widget.dart';
import '../widgets/custom_check_box.dart';
import '../../../../core/common/filter_methods.dart';
import '../barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibilling/features/ibilling/presentation/bloc/contract_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool paid = false;
  bool rejectedByIQ = false;
  bool inProcess = false;
  bool rejectedByPayme = false;
  DateTime? fromDate;
  DateTime? toDate;
  List<ContractModel> filteredContracts = [];
  bool isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    context.read<ContractBloc>().add(FetchContractsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: AppColors.darkest,
          leading: BackButton(
            color: AppColors.white,
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            "filter".tr(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ContractBloc, ContractState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("status".tr(), style: AppTextStyles.filterAboveTextStyle),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: CustomCheckBox(
                                  value: paid,
                                  onChanged: (v) =>
                                      setState(() => paid = v ?? false),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "paid".tr(),
                                style: TextStyle(
                                  color: paid
                                      ? AppColors.white6
                                      : Colors.white.withAlpha(100),
                                  fontFamily: 'Ubuntu',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: CustomCheckBox(
                                  value: rejectedByIQ,
                                  onChanged: (v) =>
                                      setState(() => rejectedByIQ = v ?? false),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "rejected_by_iq".tr(),
                                style: TextStyle(
                                  color: rejectedByIQ
                                      ? AppColors.white6
                                      : Colors.white.withAlpha(100),
                                  fontFamily: 'Ubuntu',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: CustomCheckBox(
                                  value: inProcess,
                                  onChanged: (v) =>
                                      setState(() => inProcess = v ?? false),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "in_process".tr(),
                                style: TextStyle(
                                  color: inProcess
                                      ? AppColors.white6
                                      : Colors.white.withAlpha(100),
                                  fontFamily: "Ubuntu",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: CustomCheckBox(
                                  value: rejectedByPayme,
                                  onChanged: (v) => setState(
                                    () => rejectedByPayme = v ?? false,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "rejected_by_payme".tr(),
                                style: TextStyle(
                                  color: rejectedByPayme
                                      ? AppColors.white6
                                      : Colors.white.withAlpha(100),
                                  fontFamily: "Ubuntu",
                                  fontSize: 15.8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text("Date".tr(), style: AppTextStyles.filterAboveTextStyle),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
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
                            color: Colors.white,
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
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "cancel".tr(),
                            textColor: AppColors.darkGreen,
                            backColor: AppColors.darkGreen.withAlpha(80),
                            onTap: () => _resetFilters(),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: CustomButton(
                            text: "apply_filters".tr(),
                            textColor: AppColors.white7,
                            backColor: AppColors.darkGreen,
                            onTap: () => _applyFilters(
                              state.contracts
                                  .map((e) => ContractModel.fromEntity(e))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Filtered contracts section
                  if (isFilterApplied) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          "Filtered Results",
                          style: AppTextStyles.filterAboveTextStyle,
                        ),
                        const Spacer(),
                        Text(
                          "${filteredContracts.length} contracts",
                          style: TextStyle(
                            color: AppColors.white.withAlpha(150),
                            fontFamily: 'Ubuntu',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: FilterMethods.buildFilteredContractsList(
                        filteredContracts: filteredContracts,
                        onContractTap: _navigateToContractDetails,
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NoMadeWidget(
                              text: "apply_filters_to_see_results".tr(),
                              iconUrl: AppIcons.documentIcon,
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _applyFilters(List<ContractModel> allContracts) {
    setState(() {
      filteredContracts = FilterMethods.applyFilters(
        allContracts: allContracts,
        paid: paid,
        rejectedByIQ: rejectedByIQ,
        inProcess: inProcess,
        rejectedByPayme: rejectedByPayme,
        fromDate: fromDate,
        toDate: toDate,
      );
      isFilterApplied = true;
    });
  }

  void _resetFilters() {
    setState(() {
      paid = false;
      rejectedByIQ = false;
      inProcess = false;
      rejectedByPayme = false;
      fromDate = null;
      toDate = null;
      filteredContracts = [];
      isFilterApplied = false;
    });
  }

  void _navigateToContractDetails(ContractModel contract, int index) {
    FilterMethods.navigateToContractDetails(context, contract, index);
  }

  void _selectDate(BuildContext context, bool isFrom) async {
    await FilterMethods.selectDate(context, isFrom, fromDate, toDate, (
      picked,
      isFromDate,
    ) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    });
  }
}
