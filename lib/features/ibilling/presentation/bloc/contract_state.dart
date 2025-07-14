part of 'contract_bloc.dart';

enum ContractListStatus { initial, loading, success, failure }
enum ContractAction { none, add, delete, refresh, fetch }

class ContractState {
  final List<ContractEntity> contracts;
  final bool isLoading;
  final String? error;
  final ContractListStatus status;
  final ContractAction lastAction;

  const ContractState({
    this.contracts = const [],
    this.isLoading = false,
    this.error,
    this.status = ContractListStatus.initial,
    this.lastAction = ContractAction.none,
  });

  ContractState copyWith({
    List<ContractEntity>? contracts,
    bool? isLoading,
    String? error,
    ContractListStatus? status,
    ContractAction? lastAction,
  }) {
    // Reset error if status is not failure
    final newStatus = status ?? this.status;
    return ContractState(
      contracts: contracts ?? this.contracts,
      isLoading: isLoading ?? this.isLoading,
      error: newStatus == ContractListStatus.failure ? (error ?? this.error) : null,
      status: newStatus,
      lastAction: lastAction ?? this.lastAction,
    );
  }

  factory ContractState.initial() => ContractState();
}
