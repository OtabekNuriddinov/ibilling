import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';

abstract class ContractRepository{
  Future<Either<Failure,void>> addContract(ContractEntity contract);

  Future<Either<Failure,List<ContractEntity>>> fetchContracts();

  Future<Either<Failure,void>>deleteContract(String id);
}