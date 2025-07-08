import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';

abstract class ContractRepository{
  Future<void> addContract(ContractEntity contract);

  Future<List<ContractEntity>> fetchContracts();

  Future<void> deleteContract(String id);
}