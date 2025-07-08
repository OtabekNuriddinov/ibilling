import 'package:ibilling/core/common/common_methods.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  ContractModel({
    required super.id,
    required super.personType,
    required super.fullName,
    required super.address,
    required super.inn,
    required super.amount,
    required super.lastInvoiceNumber,
    required super.numberOfInvoices,
    required super.date,
    required super.status,
    required super.statusLabel,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] == null
          ? null
          : (json['id'] is String
                ? json['id'].toString()
                : json['id'].toString()),
      personType: json['personType'] as String,
      fullName: json['fullName'] as String,
      address: json['address'] as String,
      inn: json['inn'] as String,
      amount: json['amount'] as String,
      lastInvoiceNumber: json['lastInvoiceNumber'] is int
          ? json['lastInvoiceNumber']
          : int.tryParse(json['lastInvoiceNumber'].toString()) ?? 0,
      numberOfInvoices: json['numberOfInvoices'] is int
          ? json['numberOfInvoices']
          : int.tryParse(json['numberOfInvoices'].toString()) ?? 0,
      date: DateTime.parse(json['date'] as String),
      status: CommonMethods.statusFromFirestoreUniversal(
        json['status'] as String,
        CommonMethods.contractFirestoreMap,
        ContractStatus.inProcess,
      ),
      statusLabel: json['statusLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personType': personType,
      'fullName': fullName,
      'address': address,
      'inn': inn,
      'amount': amount,
      'lastInvoiceNumber': lastInvoiceNumber,
      'numberOfInvoices': numberOfInvoices,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      'statusLabel': statusLabel,
    };
  }

  factory ContractModel.fromEntity(ContractEntity entity) {
    return ContractModel(
      id: entity.id,
      personType: entity.personType,
      fullName: entity.fullName,
      address: entity.address,
      inn: entity.inn,
      amount: entity.amount,
      lastInvoiceNumber: entity.lastInvoiceNumber,
      numberOfInvoices: entity.numberOfInvoices,
      date: entity.date,
      status: entity.status,
      statusLabel: entity.statusLabel,
    );
  }
}
