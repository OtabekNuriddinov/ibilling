import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

class ContractsPage extends StatefulWidget {
  final List<ContractEntity>? filteredContracts;
  const ContractsPage({super.key, this.filteredContracts});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage>
    with SingleTickerProviderStateMixin {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  int selectedIndex = 0;
  late List<ContractEntity> _contracts = [];
  bool _isLoading = false;
  bool _hasReachedMax = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool isTab = false;
  final ScrollController _scrollController = ScrollController();
  final List<InvoiceEntity> _invoices = [];
  bool _isInvoiceLoading = false;
  int _invoicePage = 1;
  final int _invoicePageSize = 10;
  bool _hasReachedMaxInvoices = false;
  double _topPadding = 32;
  bool _isFilterApplied = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        selectedIndex = _tabController.index;
        if (selectedIndex == 0) {
          _contracts.clear();
          _currentPage = 1;
          _hasReachedMax = false;
          _loadContracts();
        } else {
          _invoices.clear();
          _invoicePage = 1;
          _hasReachedMaxInvoices = false;
          _loadInvoices();
        }
      });
    });
    if (widget.filteredContracts != null) {
      _contracts = [...widget.filteredContracts!];
      _isFilterApplied = true;
    } else {
      _contracts = [];
      _loadContracts();
    }
    _scrollController.addListener(_handleScrollPadding);
    IBillingLocalDataSource.loadSelectedIndex().then((value) {});
    _loadInvoices();
  }

  @override
  void didUpdateWidget(covariant ContractsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filteredContracts != oldWidget.filteredContracts) {
      if (widget.filteredContracts != null) {
        setState(() {
          _contracts = [...widget.filteredContracts!];
          _isFilterApplied = true;
        });
      } else {
        setState(() {
          _isFilterApplied = false;
          _contracts.clear();
          _currentPage = 1;
          _hasReachedMax = false;
        });
        _loadContracts();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScrollPadding);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool get shouldShowTab {
    if (_invoices.isEmpty && _contracts.isEmpty) {
      return false;
    }
    return true;
  }

  void _clearFilter() {
    context.go('/contracts');
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
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _topPadding,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: selectedIndex == 0 ? _onRefresh : _onRefreshInvoices,
              color: AppColors.darkGreen,
              backgroundColor: Colors.black,
              displacement: 42,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    shouldShowTab
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 240,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    color: AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorPadding: EdgeInsets.zero,
                                  dividerColor: Colors.transparent,
                                  labelColor: AppColors.white,
                                  unselectedLabelColor: AppColors.white,
                                  labelStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  tabs: [
                                    Tab(text: "contracts".tr()),
                                    Tab(text: "invoice".tr()),
                                  ],
                                ),
                              ),
                              if (_isFilterApplied)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: TextButton(
                                      onPressed: _clearFilter,
                                      child: Text(
                                        "clear_filter".tr(),
                                        style: TextStyle(
                                          color: AppColors.darkGreen,
                                          fontFamily: 'Ubuntu',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 8),
                    selectedIndex == 0
                        ? ContractsListWidget(
                            isLoading: _isLoading,
                            contracts: _contracts,
                            hasReachedMax: _hasReachedMax,
                            onLoadMore: _isFilterApplied
                                ? null
                                : _loadContracts,
                            onRefresh: _onRefresh,
                          )
                        : InvoicesListWidget(
                            isLoading: _isInvoiceLoading,
                            invoices: _invoices,
                            hasReachedMax: _hasReachedMaxInvoices,
                            onLoadMore: _loadInvoices,
                            onRefresh: _onRefreshInvoices,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadContracts() async {
    if (_isFilterApplied) return;
    setState(() => _isLoading = true);
    try {
      final getContracts = getIt<GetContracts>();
      final result = await getContracts();
      result.fold(
        (failure) {
          setState(() {
            _isLoading = false;
            debugPrint(failure.message);
          });
        },
        (allContracts) {
          final filtered = allContracts.where((contract) {
            return contract.date.year == _selectedDay.year &&
                contract.date.month == _selectedDay.month &&
                contract.date.day == _selectedDay.day;
          }).toList();
          filtered.sort(
            (a, b) => (int.tryParse(a.id ?? '0') ?? 0).compareTo(
              int.tryParse(b.id ?? '0') ?? 0,
            ),
          );
          final start = (_currentPage - 1) * _pageSize;
          final newContracts = filtered.skip(start).take(_pageSize).toList();
          setState(() {
            _contracts.addAll(newContracts);
            _isLoading = false;
            _currentPage++;
            if (newContracts.length < _pageSize) _hasReachedMax = true;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    if (_isFilterApplied) return;
    setState(() {
      _contracts.clear();
      _currentPage = 1;
      _hasReachedMax = false;
    });
    await _loadContracts();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isInvoiceLoading = true);
    try {
      final getInvoices = getIt<GetInvoices>();
      final result = await getInvoices();
      result.fold(
        (failure) {
          setState(() {
            _isInvoiceLoading = false;
            debugPrint(failure.message);
          });
        },
        (allInvoices) {
          final filtered = allInvoices.where((invoice) {
            return invoice.date.year == _selectedDay.year &&
                invoice.date.month == _selectedDay.month &&
                invoice.date.day == _selectedDay.day;
          }).toList();
          filtered.sort(
            (a, b) => (int.tryParse(a.id ?? "0") ?? 0).compareTo(
              int.tryParse(b.id ?? "0") ?? 0,
            ),
          );
          final start = (_invoicePage - 1) * _invoicePageSize;
          final newInvoices = filtered
              .skip(start)
              .take(_invoicePageSize)
              .toList();
          setState(() {
            _invoices.addAll(newInvoices);
            _isInvoiceLoading = false;
            _invoicePage++;
            if (newInvoices.length < _invoicePageSize)
              _hasReachedMaxInvoices = true;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isInvoiceLoading = false;
      });
    }
  }

  Future<void> _onRefreshInvoices() async {
    setState(() {
      _invoices.clear();
      _invoicePage = 1;
      _hasReachedMaxInvoices = false;
    });
    await _loadInvoices();
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;

      if (selectedIndex == 0) {
        _contracts.clear();
        _currentPage = 1;
        _hasReachedMax = false;
        _loadContracts();
      } else {
        _invoices.clear();
        _invoicePage = 1;
        _hasReachedMaxInvoices = false;
        _loadInvoices();
      }
    });
  }

  void _handleScrollPadding() {
    double newPadding = _scrollController.offset > 0 ? 0 : 32;
    if (_topPadding != newPadding) {
      setState(() {
        _topPadding = newPadding;
      });
    }
  }
}
