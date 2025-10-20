import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        super(PaymentInitial()) {
    on<MakePaymentEvent>(_onMakePayment);
    on<LoadTontinePaymentsEvent>(_onLoadTontinePayments);
  }

  Future<void> _onMakePayment(
    MakePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final payment = await _paymentRepository.makePayment(
        tontineId: event.tontineId,
        amount: event.amount,
        provider: event.provider,
      );
      emit(PaymentSuccess(payment: payment));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadTontinePayments(
    LoadTontinePaymentsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final payments =
          await _paymentRepository.getTontinePayments(event.tontineId);
      emit(PaymentsLoaded(payments: payments));
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }
}
