import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/barrel.dart';
import '../widgets/no_made_widget.dart';
import '../widgets/selectable_card.dart';
import '../barrel.dart';
import 'package:ibilling/features/ibilling/data/datasources/ibilling_local_datasource.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int selectedIndex = 0;

  final List<ContractEntity> _contracts = [];
  bool _isLoading = false;
  bool _hasReachedMax = false;
  String? _error;
  int _currentPage = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  final List<InvoiceEntity> _invoices = [];
  bool _isInvoiceLoading = false;
  String? _invoiceError;

  @override
  void initState() {
    super.initState();
    IBillingLocalDataSource.loadSelectedIndex().then((value) {
      setState(() {
        selectedIndex = value;
      });
    });
    _loadContracts();
    _loadInvoices();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_hasReachedMax && selectedIndex == 0) {
        _loadContracts();
      }
    }
  }

  Future<void> _loadContracts() async {
    setState(() => _isLoading = true);
    try {
      final getContracts = getIt<GetContracts>();
      final allContracts = await getContracts();
      final filtered = allContracts.where((contract) {
        return contract.date.year == _selectedDay.year &&
            contract.date.month == _selectedDay.month &&
            contract.date.day == _selectedDay.day;
      }).toList();
      final start = (_currentPage - 1) * _pageSize;
      final newContracts = filtered.skip(start).take(_pageSize).toList();
      setState(() {
        _contracts.addAll(newContracts);
        _isLoading = false;
        _currentPage++;
        if (newContracts.length < _pageSize) _hasReachedMax = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadInvoices() async {
    setState(() {
      _isInvoiceLoading = true;
      _invoiceError = null;
      _invoices.clear();
    });
    try {
      final getInvoices = getIt<GetInvoices>();
      final allInvoices = await getInvoices();
      final filtered = allInvoices
          .where(
            (invoice) =>
                invoice.date.year == _selectedDay.year &&
                invoice.date.month == _selectedDay.month &&
                invoice.date.day == _selectedDay.day,
          )
          .toList();
      setState(() {
        _invoices.addAll(filtered);
        _isInvoiceLoading = false;
      });
    } catch (e) {
      setState(() {
        _invoiceError = e.toString();
        _isInvoiceLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    if (selectedIndex == 0) {
      setState(() {
        _contracts.clear();
        _error = null;
        _currentPage = 1;
        _hasReachedMax = false;
      });
      await _loadContracts();
    } else {
      await _loadInvoices();
    }
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
      _contracts.clear();
      _currentPage = 1;
      _hasReachedMax = false;
      _invoices.clear();
    });
    _loadContracts();
    _loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods.customAppBar(
        backColor: AppColors.black,
        context: context,
        filterPressed: () {
          context.go('/contracts/filter');
        },
        iconPressed: () {
          context.go('/contracts/search');
        },
        title: "contracts".tr(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.2.h,
            width: double.infinity,
            color: AppColors.darker,
            child: Column(
              children: [
                CalendarHeader(
                  focusedDay: _focusedDay,
                  onLeftArrow: () {
                    setState(() {
                      _focusedDay = _focusedDay.subtract(Duration(days: 6));
                    });
                  },
                  onRightArrow: () {
                    setState(() {
                      _focusedDay = _focusedDay.add(const Duration(days: 6));
                    });
                  },
                ),
                CustomWeekCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  onDaySelected: _onDaySelected,
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SelectableCard(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 0;
                              _contracts.clear();
                              _currentPage = 1;
                              _hasReachedMax = false;
                            });
                            _loadContracts();
                          },
                          selectedIndex: selectedIndex,
                          currentIndex: 0,
                          text: "contracts".tr(),
                        ),
                        SizedBox(width: 2.w),
                        SelectableCard(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                            _loadInvoices();
                          },
                          selectedIndex: selectedIndex,
                          currentIndex: 1,
                          text: "invoice".tr(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: selectedIndex == 0
                        ? _buildContractsList()
                        : _buildInvoicesList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractsList() {
    if (_isLoading && _contracts.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.lightGreen),
      );
    }
    if (_error != null && _contracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.withAlpha(150),
              size: 20.sp,
            ),
            SizedBox(height: 2.h),
            Text(
              '${"error".tr()}: $_error',
              style: TextStyle(
                color: Colors.red.withAlpha(150),
                fontSize: 16.sp,
                fontFamily: 'Ubuntu',
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _loadContracts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                foregroundColor: AppColors.white,
              ),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }
    if (_contracts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: NoMadeWidget(
            text: "no_contracts".tr(),
            iconUrl: AppIcons.documentIcon,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.darkGreen,
      backgroundColor: AppColors.black,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _contracts.length + (_hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _contracts.length) {
            if (_isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.darkGreen
                  ),
                  ),
                ),
              );
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: ElevatedButton(
                  onPressed: _loadContracts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                  ),
                  child: Text("Load more", style: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  ),
                ),
              ),
            );
          }
          final contract = _contracts[index];
          return Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                context.go(
                  '/contracts/contract_details',
                  extra: {
                    'contract': ContractModel.fromEntity(contract),
                    'displayIndex': index + 1,
                  },
                );
              },
              child: ContractCard(
                contract: ContractModel.fromEntity(contract),
                displayIndex: index + 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoicesList() {
    if (_isInvoiceLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.lightGreen),
      );
    }
    if (_invoiceError != null) {
      return Center(child: Text('Error: $_invoiceError'));
    }
    if (_invoices.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: NoMadeWidget(
            text: "no_invoices".tr(),
            iconUrl: AppIcons.documentIcon,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.darkGreen,
      backgroundColor: AppColors.black,
      child: ListView.builder(
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final invoice = _invoices[index];
          return InvoiceCard(
            invoice: InvoiceModel.fromEntity(invoice),
            displayIndex: index + 1,
          );
        },
      ),
    );
  }
}
