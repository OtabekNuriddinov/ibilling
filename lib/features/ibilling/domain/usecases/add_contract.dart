import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/contract_repository.dart';

class AddContract{
  final ContractRepository repository;

  AddContract(this.repository);

  Future<void> call(ContractEntity contract)async{
    await repository.addContract(contract);
  }
}

