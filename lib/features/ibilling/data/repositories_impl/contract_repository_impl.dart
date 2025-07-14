import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/contract_repository.dart';
import 'package:dartz/dartz.dart';
import '../datasources/ibilling_remote_datasources.dart';

class ContractRepositoryImpl implements ContractRepository{
  final IBillingRemoteDataSource remoteDataSource;

  ContractRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure,void>> addContract(ContractEntity contract)async {
    try{
      await remoteDataSource.addContract(contract);
      return const Right(null);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,List<ContractEntity>>> fetchContracts() async{
    try{
      final contracts = await remoteDataSource.fetchContracts();
      return Right(contracts);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,void>> deleteContract(String id) async{
    try{
      await remoteDataSource.deleteContract(id);
      return const Right(null);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }
}