import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibilling/features/ibilling/domain/entities/invoice_entity.dart';
import '../../domain/usecases/add_invoice.dart';
import '../../domain/usecases/get_invoices.dart';

part 'invoice_state.dart';
part 'invoice_event.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final AddInvoice addInvoice;
  final GetInvoices getInvoices;

  InvoiceBloc(this.addInvoice, this.getInvoices) : super(const InvoiceState()) {
    on<AddInvoiceEvent>(_addInvoiceFunc);
    on<FetchInvoicesEvent>(_fetchInvoicesFunc);
  }

  Future<void> _addInvoiceFunc(
    AddInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceListStatus.loading));

    final addResult = await addInvoice(event.invoice);

    addResult.fold(
      (failure) => emit(
        state.copyWith(
          status: InvoiceListStatus.failure,
          error: failure.message,
        ),
      ),
      (_) async {
        final invoicesResult = await getInvoices();
        invoicesResult.fold(
          (failure) => emit(state.copyWith()),
          (invoices) => emit(
            state.copyWith(
              invoices: invoices,
              status: InvoiceListStatus.success,
              error: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchInvoicesFunc(
    FetchInvoicesEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceListStatus.loading));

    final result = await getInvoices();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InvoiceListStatus.failure,
          error: failure.message,
        ),
      ),
      (invoices) => emit(
        state.copyWith(invoices: invoices, status: InvoiceListStatus.success),
      ),
    );
  }
}
