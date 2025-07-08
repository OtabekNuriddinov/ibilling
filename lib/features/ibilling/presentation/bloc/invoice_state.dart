part of 'invoice_bloc.dart';

enum InvoiceListStatus { initial, loading, success, failure }

class InvoiceState {
  final List<InvoiceEntity> invoices;
  final InvoiceListStatus status;
  final String? error;

  const InvoiceState({
    this.invoices = const [],
    this.status = InvoiceListStatus.initial,
    this.error,
  });

  InvoiceState copyWith({
    List<InvoiceEntity>? invoices,
    InvoiceListStatus? status,
    String? error,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      status: status ?? this.status,
      error: error,
    );
  }
}