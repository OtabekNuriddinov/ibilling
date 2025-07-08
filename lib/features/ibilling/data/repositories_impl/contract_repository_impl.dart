import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/contract_repository.dart';
import '../datasources/ibilling_remote_datasources.dart';

class ContractRepositoryImpl implements ContractRepository{
  final IBillingRemoteDataSource remoteDataSource;

  ContractRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addContract(ContractEntity contract)async {
    await remoteDataSource.addContract(contract);
  }

  @override
  Future<List<ContractEntity>> fetchContracts() async{
    return await remoteDataSource.fetchContracts();
  }

  @override
  Future<void> deleteContract(String id) async{
    return await remoteDataSource.deleteContract(id);
  }
}