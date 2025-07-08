import 'package:ibilling/features/ibilling/data/datasources/ibilling_remote_datasources.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final IBillingRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addInvoice(InvoiceEntity invoice) async {
    await remoteDataSource.addInvoice(invoice);
  }

  @override
  Future<List<InvoiceEntity>> fetchInvoices() async {
    return await remoteDataSource.fetchInvoices();
  }
}