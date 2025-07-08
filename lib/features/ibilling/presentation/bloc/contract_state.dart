part of 'contract_bloc.dart';

enum ContractListStatus {initial, loading, success, failure}

class ContractState {
  final List<ContractEntity> contracts;
  final bool isLoading;
  final String? error;
  final ContractListStatus status;

  const ContractState({
    this.contracts = const [],
    this.isLoading = false,
    this.error,
    this.status = ContractListStatus.initial,
  });

  ContractState copyWith({
    List<ContractEntity>? contracts,
    bool? isLoading,
    String? error,
    ContractListStatus? status,
  }) {
    return ContractState(
      contracts: contracts ?? this.contracts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      status: status ?? this.status,
    );
  }

  factory ContractState.initial() => ContractState();
}
