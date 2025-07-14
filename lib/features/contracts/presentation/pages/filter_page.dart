import '../barrel.dart';
import 'package:easy_localization/easy_localization.dart';


/// Understand filter
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
  bool isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    context.read<ContractBloc>().add(FetchContracts());
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
            if (state.status == ContractListStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ContractListStatus.failure) {
              return Center(child: Text('Error:  ${state.error ?? "Unknown error"}'));
            }
            final allContracts = state.contracts;
            final filteredContracts = FilterMethods.applyFilters(
              allContracts: allContracts
                  .map((e) => ContractModel.fromEntity(e))
                  .toList(),
              paid: paid,
              rejectedByIQ: rejectedByIQ,
              inProcess: inProcess,
              rejectedByPayme: rejectedByPayme,
              fromDate: fromDate,
              toDate: toDate,
            );
            
            // Check if any filters are applied
            final hasActiveFilters = paid || rejectedByIQ || inProcess || rejectedByPayme || fromDate != null || toDate != null;
            
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "status".tr(),
                    style: AppTextStyles.filterAboveTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                   CustomCheckBox(
                                      value: paid,
                                      onChanged: (v) => setState(() => paid = v ?? false),
                                      text: "paid",
                                   ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  CustomCheckBox(
                                      value: inProcess,
                                      onChanged: (v) => setState(() => inProcess = v ?? false),
                                      text: "in_process",
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomCheckBox(
                                      value: rejectedByIQ,
                                      onChanged: (v) => setState(() => rejectedByIQ = v ?? false),
                                      text: "rejected_by_iq",
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  CustomCheckBox(
                                      value: rejectedByPayme,
                                      onChanged: (v) => setState(() => rejectedByPayme = v ?? false),
                                      text: "rejected_by_payme",
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                  Text(
                    "Date".tr(),
                    style: AppTextStyles.filterAboveTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                      const SizedBox(width: 12),
                      Text(
                        '-',
                        style: TextStyle(
                          color: Colors.white.withAlpha(100),
                          fontSize: 26.sp,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DateSelectable(
                        label: 'to'.tr(),
                        date: toDate,
                        onPressed: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  const Spacer(),

                  if (filteredContracts.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "${filteredContracts.length} ${filteredContracts.length == 1 ? 'contract'.tr() : 'contracts'.tr()} ${'found'.tr()}",
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontFamily: 'Ubuntu',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (hasActiveFilters)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "no_contracts_match".tr(),
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontFamily: 'Ubuntu',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "cancel".tr(),
                          textColor: AppColors.darkGreen.withAlpha(1000),
                          backColor: AppColors.darkGreen.withAlpha(90),
                          onTap: () => _resetFilters(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: "apply_filters".tr(),
                          textColor: AppColors.white7,
                          backColor: AppColors.darkGreen,
                          onTap: () {
                            final filteredList = filteredContracts
                                .map(
                                  (e) => ContractEntity(
                                    id: e.id,
                                    personType: e.personType,
                                    fullName: e.fullName,
                                    address: e.address,
                                    inn: e.inn,
                                    amount: e.amount,
                                    lastInvoiceNumber:
                                        e.lastInvoiceNumber,
                                    numberOfInvoices: e.numberOfInvoices,
                                    date: e.date,
                                    status: e.status,
                                    statusLabel: e.statusLabel,
                                  ),
                                )
                                .toList();
                            context.go('/contracts', extra: filteredList);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      paid = false;
      rejectedByIQ = false;
      inProcess = false;
      rejectedByPayme = false;
      fromDate = null;
      toDate = null;
      isFilterApplied = false;
    });
  }

  void _selectDate(BuildContext context, bool isFrom) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    if (isFrom) {
      if (toDate != null) {
        lastDate = toDate!;
      }
      if (fromDate != null) {
        initialDate = fromDate!;
      }
    } else {
      if (fromDate != null) {
        firstDate = fromDate!;
        initialDate = fromDate!;
      }
      if (toDate != null) {
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
          if (toDate != null && picked.isAfter(toDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }
}
