import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class MakePaymentEvent extends PaymentEvent {
  final String tontineId;
  final double amount;
  final String provider;

  const MakePaymentEvent({
    required this.tontineId,
    required this.amount,
    required this.provider,
  });

  @override
  List<Object> get props => [tontineId, amount, provider];
}

class LoadTontinePaymentsEvent extends PaymentEvent {
  final String tontineId;

  const LoadTontinePaymentsEvent({required this.tontineId});

  @override
  List<Object> get props => [tontineId];
}
