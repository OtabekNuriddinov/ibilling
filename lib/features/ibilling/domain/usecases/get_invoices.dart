import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/invoice_repository.dart';

class GetInvoices {
  final InvoiceRepository repository;
  GetInvoices(this.repository);

  Future<Either<Failure,List<InvoiceEntity>>> call() async {
    return await repository.fetchInvoices();
  }
}