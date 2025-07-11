import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:ibilling/core/theme/app_colors.dart';
import 'package:ibilling/core/theme/app_icons.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/presentation/widgets/contract_card.dart';
import 'package:ibilling/features/ibilling/presentation/widgets/show_custom_date_picker.dart';

class FilterMethods {
  static Widget buildFilteredContractsList({
    required List<ContractModel> filteredContracts,
    required Function(ContractModel, int) onContractTap,
  }) {
    if (filteredContracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.noMadeSaved,
              width: 15.w,
              height: 15.h,
              colorFilter: ColorFilter.mode(
                AppColors.white.withAlpha(100),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "No contracts match your filters",
              style: TextStyle(
                color: AppColors.white.withAlpha(100),
                fontFamily: 'Ubuntu',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: filteredContracts.length,
      itemBuilder: (context, index) {
        final contract = filteredContracts[index];
        return GestureDetector(
          onTap: () => onContractTap(contract, index),
          child: ContractCard(
            contract: contract,
            displayIndex: int.tryParse(contract.id ?? '0') ?? 0,
            onPressed: ()=>navigateToContractDetails,
          ),
        );
      },
    );
  }

  static List<ContractModel> applyFilters({
    required List<ContractModel> allContracts,
    required bool paid,
    required bool rejectedByIQ,
    required bool inProcess,
    required bool rejectedByPayme,
    required DateTime? fromDate,
    required DateTime? toDate,
  }) {
    DateTime? from = fromDate != null ? DateTime(fromDate.year, fromDate.month, fromDate.day) : null;
    DateTime? to = toDate != null ? DateTime(toDate.year, toDate.month, toDate.day) : null;

    return allContracts.where((contract) {
      bool statusMatches = false;
      if (paid && contract.status == ContractStatus.paid) statusMatches = true;
      if (rejectedByIQ && contract.status == ContractStatus.rejectedByIQ) statusMatches = true;
      if (inProcess && contract.status == ContractStatus.inProcess) statusMatches = true;
      if (rejectedByPayme && contract.status == ContractStatus.rejectedByPayme) statusMatches = true;

      if (!paid && !rejectedByIQ && !inProcess && !rejectedByPayme) {
        statusMatches = true;
      }

      bool dateMatches = true;
      final contractDate = DateTime(contract.date.year, contract.date.month, contract.date.day);

      if (from != null && to == null) {
        dateMatches = contractDate == from;
      } else if (from == null && to != null) {
        dateMatches = contractDate == to;
      } else if (from != null && to != null) {
        if (from == to) {
          dateMatches = contractDate == from;
        } else {
          dateMatches = (contractDate.isAtSameMomentAs(from) || contractDate.isAfter(from)) &&
                        (contractDate.isAtSameMomentAs(to) || contractDate.isBefore(to));
        }
      }
      // Aks holda (ikkalasi null) dateMatches true bo‘lib qoladi

      return statusMatches && dateMatches;
    }).toList();
  }

  static void navigateToContractDetails(
    BuildContext context,
    ContractModel contract,
    int index,
  ) {
    context.go(
      '/contracts/contract_details',
      extra: {
        'contract': contract,
        'displayIndex': index + 1,
      },
    );
  }
  static Future<void> selectDate(
    BuildContext context,
    bool isFrom,
    DateTime? fromDate,
    DateTime? toDate,
    Function(DateTime?, bool) onDateSelected,
  ) async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
    );
    if (picked != null) {
      onDateSelected(picked, isFrom);
    }
  }
} 