import 'package:equatable/equatable.dart';
import '../../models/payment_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentModel payment;

  const PaymentSuccess({required this.payment});

  @override
  List<Object> get props => [payment];
}

class PaymentsLoaded extends PaymentState {
  final List<PaymentModel> payments;

  const PaymentsLoaded({required this.payments});

  @override
  List<Object> get props => [payments];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure({required this.error});

  @override
  List<Object> get props => [error];
}
