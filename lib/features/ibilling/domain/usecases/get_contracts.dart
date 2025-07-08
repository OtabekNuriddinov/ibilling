import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/repositories/contract_repository.dart';

class GetContracts {
  final ContractRepository repository;
  GetContracts(this.repository);

  Future<List<ContractEntity>> call() async {
    return await repository.fetchContracts();
  }
}