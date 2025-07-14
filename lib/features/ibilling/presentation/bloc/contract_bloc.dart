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
    if (state.contracts.isNotEmpty) return;
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        status: ContractListStatus.loading,
      ),
    );

    final result = await getContracts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
        ),
      ),
      (contracts) => emit(
        state.copyWith(
          contracts: contracts,
          isLoading: false,
          status: ContractListStatus.success,
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
      ),
    );
    final result = await getContracts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
        ),
      ),
      (contracts) => emit(
        state.copyWith(
          contracts: contracts,
          isLoading: false,
          status: ContractListStatus.success,
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
        lastAction: ContractAction.none,
      ),
    );
    final addResult = await addContract(event.contract);
    addResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
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
            ),
          ),
          (contracts) => emit(
            state.copyWith(
              contracts: contracts,
              isLoading: false,
              status: ContractListStatus.success,
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
        lastAction: ContractAction.none,
      ),
    );
    final deleteResult = await deleteContract(event.id);
    deleteResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          status: ContractListStatus.failure,
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
