part of 'invoice_bloc.dart';
abstract class InvoiceEvent {}

class AddInvoiceEvent extends InvoiceEvent {
  final InvoiceEntity invoice;
  AddInvoiceEvent(this.invoice);
}

class FetchInvoicesEvent extends InvoiceEvent {}