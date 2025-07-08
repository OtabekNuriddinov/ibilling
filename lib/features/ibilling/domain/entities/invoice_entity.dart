enum InvoiceStatus { paid, inProcess, rejectedByPayme, rejectedByIQ }

class InvoiceEntity {
  final String? id;
  final String serviceName;
  final String amount;
  final InvoiceStatus status;
  final String statusLabel;
  final DateTime date;

  InvoiceEntity({
    required this.id,
    required this.serviceName,
    required this.amount,
    required this.status,
    required this.statusLabel,
    required this.date,
  });
}