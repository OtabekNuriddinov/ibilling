import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/data/datasources/ibilling_remote_datasources.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final IBillingRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure,void>> addInvoice(InvoiceEntity invoice) async {
    try{
      await remoteDataSource.addInvoice(invoice);
      return Right(null);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,List<InvoiceEntity>>> fetchInvoices() async {
    try{
      final invoices = await remoteDataSource.fetchInvoices();
      return Right(invoices);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }
}