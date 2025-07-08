import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/invoice_repository.dart';

class AddInvoice {
  final InvoiceRepository repository;
  AddInvoice(this.repository);

  Future<void> call(InvoiceEntity invoice) async {
    await repository.addInvoice(invoice);
  }
}

