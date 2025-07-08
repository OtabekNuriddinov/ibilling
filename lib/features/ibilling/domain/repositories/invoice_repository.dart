import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<void> addInvoice(InvoiceEntity invoice);
  Future<List<InvoiceEntity>> fetchInvoices();
}