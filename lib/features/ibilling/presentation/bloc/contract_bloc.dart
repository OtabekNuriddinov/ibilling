import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibilling/features/ibilling/domain/entities/contract_entity.dart';
import 'package:ibilling/features/ibilling/domain/usecases/add_contract.dart';
import 'package:ibilling/features/ibilling/domain/usecases/get_contracts.dart';
import 'package:ibilling/features/ibilling/domain/usecases/delete_contract.dart';
part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final AddContract addContract;
  final GetContracts getContracts;
  final DeleteContract deleteContract;

  ContractBloc(this.addContract, this.getContracts, this.deleteContract)
    : super(ContractState()) {
    on<AddContractEvent>(addContractFunc);
    on<FetchContractsEvent>(fetchContractsFunc);
    on<DeleteContractEvent>(deleteContractFunc);
  }

  void addContractFunc(
    AddContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: ContractListStatus.loading));
    try {
      await addContract(event.contract);
      emit(state.copyWith(status: ContractListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContractListStatus.failure, error: "$e"));
    }
  }

  void deleteContractFunc(
    DeleteContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: ContractListStatus.loading));
    try {
      await deleteContract(event.id);
      add(FetchContractsEvent());
      emit(state.copyWith(status: ContractListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContractListStatus.failure, error: "$e"));
    }
  }

  Future<void> fetchContractsFunc(
    FetchContractsEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: ContractListStatus.loading));
    try {
      final contracts = await getContracts();
      emit(
        state.copyWith(
          contracts: contracts,
          status: ContractListStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ContractListStatus.failure, error: e.toString()),
      );
    }
  }
}
