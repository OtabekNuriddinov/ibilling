enum ContractStatus { paid, inProcess, rejectedByPayme, rejectedByIQ }

class ContractEntity {
  final String? id;
  final String personType;
  final String fullName;
  final String address;
  final String inn;
  final String amount;
  final int lastInvoiceNumber;
  final int numberOfInvoices;
  final DateTime date;
  final ContractStatus status;
  final String statusLabel;

  ContractEntity({
    required this.id,
    required this.personType,
    required this.fullName,
    required this.address,
    required this.inn,
    required this.amount,
    required this.lastInvoiceNumber,
    required this.numberOfInvoices,
    required this.date,
    required this.status,
    required this.statusLabel,
  });
}