part of 'contract_bloc.dart';

enum ContractListStatus {initial, loading, success, failure}

class ContractState {
  final List<ContractEntity> contracts;
  final ContractListStatus status;
  final String? error;

  const ContractState({
    this.contracts = const [],
    this.status = ContractListStatus.initial,
    this.error,
  });

  ContractState copyWith({
    List<ContractEntity>? contracts,
    ContractListStatus? status,
    String? error,
  }) {
    return ContractState(
      contracts: contracts ?? this.contracts,
      status: status ?? this.status,
      error: error,
    );
  }
}
