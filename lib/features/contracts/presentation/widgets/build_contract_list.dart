import 'package:easy_localization/easy_localization.dart';
import 'package:ibilling/features/contracts/presentation/widgets/no_made_widget.dart';
import '../barrel.dart';

class ContractsListWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<dynamic> contracts;
  final ScrollController scrollController;
  final bool hasReachedMax;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const ContractsListWidget({
    super.key,
    required this.isLoading,
    this.error,
    required this.contracts,
    required this.scrollController,
    required this.hasReachedMax,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && contracts.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppColors.lightGreen));
    }

    if (error != null && contracts.isEmpty) {
      return _buildErrorWidget();
    }

    if (contracts.isEmpty) {
      return _buildEmptyWidget();
    }

    return _buildListView();
  }

  Widget _buildErrorWidget() {
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
            '${"error".tr()}: $error',
            style: TextStyle(
              color: Colors.red.withAlpha(150),
              fontSize: 16.sp,
              fontFamily: 'Ubuntu',
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: onLoadMore,
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

  Widget _buildEmptyWidget() {
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

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.darkGreen,
      backgroundColor: AppColors.black,
      child: ListView.builder(
        controller: scrollController,
        itemCount: contracts.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == contracts.length) {
            return _buildLoadMoreWidget();
          }

          final contract = contracts[index];
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
                    'displayIndex': int.tryParse(contract.id ?? '0') ?? 0,
                  },
                );
              },
              child: ContractCard(
                contract: ContractModel.fromEntity(contract),
                displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreWidget() {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(
            "Loading...",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.darkGreen,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: ElevatedButton(
          onPressed: onLoadMore,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
          ),
          child: Text(
            "Load more",
            style: TextStyle(
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
}




