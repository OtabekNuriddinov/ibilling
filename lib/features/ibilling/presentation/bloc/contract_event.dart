part of 'contract_bloc.dart';

abstract class ContractEvent {}

class FetchContracts extends ContractEvent {}
class RefreshContracts extends ContractEvent {}
class AddContractEvent extends ContractEvent {
  final ContractEntity contract;
  AddContractEvent(this.contract);
}

class DeleteContractEvent extends ContractEvent {
  final String id;
  DeleteContractEvent({required this.id});
}
