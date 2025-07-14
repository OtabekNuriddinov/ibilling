import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/invoice_repository.dart';

class AddInvoice {
  final InvoiceRepository repository;
  AddInvoice(this.repository);

  Future<Either<Failure,void>> call(InvoiceEntity invoice) async {
    return await repository.addInvoice(invoice);
  }
}

