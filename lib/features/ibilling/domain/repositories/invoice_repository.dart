import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<Either<Failure,void>> addInvoice(InvoiceEntity invoice);
  Future<Either<Failure,List<InvoiceEntity>>> fetchInvoices();
}