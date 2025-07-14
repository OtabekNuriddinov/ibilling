import 'package:dartz/dartz.dart';
import 'package:ibilling/core/error/failure.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/contract_repository.dart';

class AddContract{
  final ContractRepository repository;

  AddContract(this.repository);

  Future<Either<Failure,void>> call(ContractEntity contract)async{
    return await repository.addContract(contract);
  }
}

