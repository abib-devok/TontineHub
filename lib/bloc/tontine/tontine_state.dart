import 'package:equatable/equatable.dart';
import '../../models/tontine_model.dart';

abstract class TontineState extends Equatable {
  const TontineState();

  @override
  List<Object> get props => [];
}

class TontineInitial extends TontineState {}

class TontineLoading extends TontineState {}

class TontineCreated extends TontineState {
  final TontineModel tontine;

  const TontineCreated({required this.tontine});

  @override
  List<Object> get props => [tontine];
}

class TontinesLoaded extends TontineState {
  final List<TontineModel> tontines;

  const TontinesLoaded({required this.tontines});

  @override
  List<Object> get props => [tontines];
}

class TontineFailure extends TontineState {
  final String error;

  const TontineFailure({required this.error});

  @override
  List<Object> get props => [error];
}
