import 'package:ibilling/core/common/common_methods.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  InvoiceModel({
    required super.id,
    required super.serviceName,
    required super.amount,
    required super.status,
    required super.statusLabel,
    required super.date,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] == null
          ? null
          : (json['id'] is String
              ? json['id'].toString()
              : json['id'].toString()),
      serviceName: json['serviceName'] as String,
      amount: json['amount'] as String,
      status: CommonMethods.statusFromFirestoreUniversal(
        json['status'] as String,
        CommonMethods.invoiceFirestoreMap,
        InvoiceStatus.inProcess,
      ),
      statusLabel: json['statusLabel'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'amount': amount,
      'status': status.toString().split('.').last,
      'statusLabel': statusLabel,
      'date': date.toIso8601String(),
    };
  }
  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      serviceName: entity.serviceName,
      amount: entity.amount,
      status: entity.status,
      statusLabel: entity.statusLabel,
      date: entity.date,
    );
  }
}