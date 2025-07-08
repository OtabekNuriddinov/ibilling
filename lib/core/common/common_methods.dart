import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ibilling/core/theme/app_text_styles.dart';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';
import 'package:ibilling/features/ibilling/data/model/invoice_model.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'package:intl/intl.dart';

sealed class CommonMethods {
  static AppBar customAppBar({
    required BuildContext context,
    required Function() filterPressed,
    required Function() iconPressed,
    required String title,
    required Color backColor,
  }) {
    return AppBar(
      backgroundColor: backColor,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.appBarIcon),
          SizedBox(width: 2.5.w),
          Text(
            title,
            style: AppTextStyles.appbarTextStyle,
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: filterPressed,
          child: SvgPicture.asset(AppIcons.filterIcon),
        ),
        SizedBox(width: 5.w),
        Container(width: 0.5.w, height: 2.h, color: AppColors.white),
        SizedBox(width: 5.w),
        Padding(
          padding: EdgeInsets.only(right: 1.w),
          child: GestureDetector(
            onTap: iconPressed,
            child: SvgPicture.asset(AppIcons.searchIcon),
          ),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  /// Universal Status color getter
  static Color getStatusColorUniversal(dynamic status) {
    final paid = AppColors.lightGreen;
    final inProcess = const Color(0xFFFFB800);
    final rejectedByPayme = const Color(0xFFFF426D);
    final rejectedByIQ = Color(0xFFF85379);

    final value = status.toString().split('.').last;
    switch (value) {
      case 'paid':
        return paid;
      case 'inProcess':
        return inProcess;
      case 'rejectedByPayme':
        return rejectedByPayme;
      case 'rejectedByIQ':
        return rejectedByIQ;
      default:
        return inProcess;
    }
  }

  /// Universal status from label function
  static T statusFromLabelUniversal<T>(String label, Map<String, T> mapping, T defaultValue) {
    return mapping[label] ?? defaultValue;
  }

  static T statusFromFirestoreUniversal<T>(String value, Map<String, T> mapping, T defaultValue) {
    return mapping[value] ?? defaultValue;
  }


  static final contractStatusMap = <String, ContractStatus>{
    "Paid": ContractStatus.paid,
    "In process": ContractStatus.inProcess,
    "Rejected by Payme": ContractStatus.rejectedByPayme,
    "Rejected by IQ": ContractStatus.rejectedByIQ,
  };
  /// Invoice status label mapping
  static final invoiceStatusMap = <String, InvoiceStatus>{
    "Paid": InvoiceStatus.paid,
    "In process": InvoiceStatus.inProcess,
    "Rejected by Payme": InvoiceStatus.rejectedByPayme,
    "Rejected by IQ": InvoiceStatus.rejectedByIQ,
  };
  /// Contract status firestore mapping
  static final contractFirestoreMap = <String, ContractStatus>{
    "paid": ContractStatus.paid,
    "inProcess": ContractStatus.inProcess,
    "rejectedByPayme": ContractStatus.rejectedByPayme,
    "rejectedByIQ": ContractStatus.rejectedByIQ,
  };
  /// Invoice status firestore mapping
  static final invoiceFirestoreMap = <String, InvoiceStatus>{
    "paid": InvoiceStatus.paid,
    "inProcess": InvoiceStatus.inProcess,
    "rejectedByPayme": InvoiceStatus.rejectedByPayme,
    "rejectedByIQ": InvoiceStatus.rejectedByIQ,
  };

  static Widget profileInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.4.sp,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 15.4.sp,
            ),
          ),
        ),
      ],
    );
  }

  static String formatAmount(String amount) {
    try {
      final number = int.tryParse(amount.replaceAll(',', '')) ?? 0;
      return NumberFormat('#,###', 'en_US').format(number);
    } catch (_) {
      return amount;
    }
  }

  /// Converts a status label (e.g. 'Paid') to a translation key (e.g. 'paid') for contracts and invoices
  static String statusLabelToKey(String label) {
    switch (label) {
      case 'Paid':
        return 'paid';
      case 'In process':
        return 'in_process';
      case 'Rejected by Payme':
        return 'rejected_by_payme';
      case 'Rejected by IQ':
        return 'rejected_by_iq';
      default:
        return label;
    }
  }
}
