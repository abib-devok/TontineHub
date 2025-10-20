import 'package:equatable/equatable.dart';

abstract class TontineEvent extends Equatable {
  const TontineEvent();

  @override
  List<Object> get props => [];
}

class CreateTontineEvent extends TontineEvent {
  final String name;
  final Map<String, dynamic> rules;

  const CreateTontineEvent({required this.name, required this.rules});

  @override
  List<Object> get props => [name, rules];
}

class LoadUserTontinesEvent extends TontineEvent {}
