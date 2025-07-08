import 'package:easy_localization/easy_localization.dart';
import '../barrel.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage>
    with AutomaticKeepAliveClientMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int selectedIndex = 0;

  final List<ContractEntity> _contracts = [];
  bool _isLoading = false;
  bool _hasReachedMax = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _error;
  final ScrollController _scrollController = ScrollController();

  final List<InvoiceEntity> _invoices = [];
  bool _isInvoiceLoading = false;
  String? _invoiceError;
  int _invoicePage = 1;
  final int _invoicePageSize = 10;
  bool _hasReachedMaxInvoices = false;
  final ScrollController _invoiceScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    IBillingLocalDataSource.loadSelectedIndex().then((value) {
      setState(() {
        selectedIndex = value;
      });
    });
    _loadContracts();
    _scrollController.addListener(_onScroll);
    _invoiceScrollController.addListener(_onInvoiceScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _invoiceScrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_hasReachedMax && selectedIndex == 0) {
        _loadContracts();
      }
    }
  }

  void _onInvoiceScroll() {
    if (_invoiceScrollController.position.pixels >=
        _invoiceScrollController.position.maxScrollExtent - 200) {
      if (!_isInvoiceLoading && !_hasReachedMaxInvoices && selectedIndex == 1) {
        _loadInvoices();
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
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _contracts.clear();
      _currentPage = 1;
      _hasReachedMax = false;
      _error = null;
    });
    await _loadContracts();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isInvoiceLoading = true);
    try {
      final getInvoices = getIt<GetInvoices>();
      final allInvoices = await getInvoices();
      allInvoices.sort(
        (a, b) => (int.tryParse(a.id ?? '0') ?? 0).compareTo(
          int.tryParse(b.id ?? '0') ?? 0,
        ),
      );
      final start = (_invoicePage - 1) * _invoicePageSize;
      final newInvoices = allInvoices
          .skip(start)
          .take(_invoicePageSize)
          .toList();
      setState(() {
        _invoices.addAll(newInvoices);
        _isInvoiceLoading = false;
        _invoicePage++;
        if (newInvoices.length < _invoicePageSize)
          _hasReachedMaxInvoices = true;
        _invoiceError = null;
      });
    } catch (e) {
      setState(() {
        _isInvoiceLoading = false;
        _invoiceError = e.toString();
      });
    }
  }

  Future<void> _onRefreshInvoices() async {
    setState(() {
      _invoices.clear();
      _invoicePage = 1;
      _hasReachedMaxInvoices = false;
      _invoiceError = null;
    });
    await _loadInvoices();
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
      _contracts.clear();
      _currentPage = 1;
      _hasReachedMax = false;
    });
    _loadContracts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                              _invoices.clear();
                              _invoicePage = 1;
                              _hasReachedMaxInvoices = false;
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
    {
      return ContractsListWidget(
        isLoading: _isLoading,
        error: _error,
        contracts: _contracts,
        scrollController: _scrollController,
        hasReachedMax: _hasReachedMax,
        onLoadMore: _loadContracts,
        onRefresh: _onRefresh,
      );
    }
  }

  Widget _buildInvoicesList() {
    {
      return InvoicesListWidget(
        isLoading: _isInvoiceLoading,
        error: _invoiceError,
        invoices: _invoices,
        scrollController: _invoiceScrollController,
        hasReachedMax: _hasReachedMaxInvoices,
        onLoadMore: _loadInvoices,
        onRefresh: _onRefreshInvoices,
        onInvoiceTap: (invoice) {},
      );
    }
  }
}
