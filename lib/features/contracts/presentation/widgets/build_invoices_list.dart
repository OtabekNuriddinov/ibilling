import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ibilling/barrel.dart';
import 'package:ibilling/core/theme/app_colors.dart';
import 'package:ibilling/core/theme/app_icons.dart';
import 'package:ibilling/features/contracts/presentation/widgets/invoice_card.dart';
import 'package:ibilling/features/contracts/presentation/widgets/no_made_widget.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';

class InvoicesListWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<dynamic> invoices;
  final bool hasReachedMax;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final Function(dynamic invoice)? onInvoiceTap;

  const InvoicesListWidget({
    super.key,
    required this.isLoading,
    this.error,
    required this.invoices,
    required this.hasReachedMax,
    required this.onLoadMore,
    required this.onRefresh,
    this.onInvoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && invoices.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppColors.lightGreen));
    }

    if (error != null && invoices.isEmpty) {
      return _buildErrorWidget();
    }

    if (invoices.isEmpty) {
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
        padding: EdgeInsets.only(top: 140),
        child: NoMadeWidget(
          text: "no_invoices".tr(),
          iconUrl: AppIcons.documentIcon,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return  ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: invoices.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == invoices.length) {
            return _buildLoadMoreWidget();
          }
          final invoice = invoices[index];
          return InvoiceCard(
            onPressed: (){},
                invoice: InvoiceModel.fromEntity(invoice),
                displayIndex: int.tryParse(invoice.id ?? '0') ?? 0,
              );
        },
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