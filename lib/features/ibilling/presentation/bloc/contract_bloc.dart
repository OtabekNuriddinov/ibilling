import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/usecases/get_contracts.dart';
import 'package:ibilling/features/ibilling/domain/usecases/add_contract.dart';
import 'package:ibilling/features/ibilling/domain/usecases/delete_contract.dart';
part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final GetContracts getContracts;
  final AddContract addContract;
  final DeleteContract deleteContract;

  ContractBloc(this.addContract, this.getContracts, this.deleteContract)
    : super(ContractState.initial()) {
    on<FetchContracts>(_onFetchContracts);
    on<RefreshContracts>(_onRefreshContracts);
    on<AddContractEvent>(_onAddContract);
    on<DeleteContractEvent>(_onDeleteContract);
  }

  Future<void> _onFetchContracts(
    FetchContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        status: ContractListStatus.loading,
        lastAction: ContractAction.fetch,
      ),
    );
    final result = await getContracts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
          lastAction: ContractAction.fetch,
        ),
      ),
      (contracts) => emit(
        state.copyWith(
          contracts: contracts,
          isLoading: false,
          status: ContractListStatus.success,
          lastAction: ContractAction.fetch,
        ),
      ),
    );
  }

  Future<void> _onRefreshContracts(
    RefreshContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        status: ContractListStatus.loading,
        lastAction: ContractAction.refresh,
      ),
    );
    final result = await getContracts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
          lastAction: ContractAction.refresh,
        ),
      ),
      (contracts) => emit(
        state.copyWith(
          contracts: contracts,
          isLoading: false,
          status: ContractListStatus.success,
          lastAction: ContractAction.refresh,
        ),
      ),
    );
  }

  Future<void> _onAddContract(
    AddContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        status: ContractListStatus.loading,
        lastAction: ContractAction.add,
      ),
    );
    final addResult = await addContract(event.contract);
    await addResult.fold(
      (failure) async => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
          lastAction: ContractAction.add,
        ),
      ),
      (_) async {
        final contractResult = await getContracts();
        contractResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              error: failure.message,
              status: ContractListStatus.failure,
              lastAction: ContractAction.add,
            ),
          ),
          (contracts) => emit(
            state.copyWith(
              contracts: contracts,
              isLoading: false,
              status: ContractListStatus.success,
              lastAction: ContractAction.add,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onDeleteContract(
    DeleteContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        status: ContractListStatus.loading,
        lastAction: ContractAction.delete,
      ),
    );
    final deleteResult = await deleteContract(event.id);
    await deleteResult.fold(
      (failure) async => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
          lastAction: ContractAction.delete,
        ),
      ),
      (_) async {
        final contractsResult = await getContracts();
        contractsResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              error: failure.message,
              status: ContractListStatus.failure,
              lastAction: ContractAction.delete,
            ),
          ),
          (contracts) => emit(
            state.copyWith(
              contracts: contracts,
              isLoading: false,
              status: ContractListStatus.success,
              lastAction: ContractAction.delete,
            ),
          ),
        );
      },
    );
  }
}
