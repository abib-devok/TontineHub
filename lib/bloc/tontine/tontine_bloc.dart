import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/tontine_repository.dart';
import 'tontine_event.dart';
import 'tontine_state.dart';

class TontineBloc extends Bloc<TontineEvent, TontineState> {
  final TontineRepository _tontineRepository;

  TontineBloc({required TontineRepository tontineRepository})
      : _tontineRepository = tontineRepository,
        super(TontineInitial()) {
    on<CreateTontineEvent>(_onCreateTontine);
    on<LoadUserTontinesEvent>(_onLoadUserTontines);
    on<LeaveTontineEvent>(_onLeaveTontine); // Ajouter le gestionnaire
  }

  Future<void> _onCreateTontine(
    CreateTontineEvent event,
    Emitter<TontineState> emit,
  ) async {
    emit(TontineLoading());
    try {
      final tontine = await _tontineRepository.createTontine(
        name: event.name,
        rules: event.rules,
      );
      emit(TontineCreated(tontine: tontine));
    } catch (e) {
      emit(TontineFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadUserTontines(
    LoadUserTontinesEvent event,
    Emitter<TontineState> emit,
  ) async {
    emit(TontineLoading());
    try {
      final tontines = await _tontineRepository.getUserTontines();
      emit(TontinesLoaded(tontines: tontines));
    } catch (e) {
      emit(TontineFailure(error: e.toString()));
    }
  }

  // Nouveau gestionnaire pour l'événement LeaveTontineEvent
  Future<void> _onLeaveTontine(
    LeaveTontineEvent event,
    Emitter<TontineState> emit,
  ) async {
    emit(TontineLoading());
    try {
      await _tontineRepository.leaveTontine(event.tontineId);
      emit(TontineLeft());
      // Après avoir quitté, recharger la liste des tontines de l'utilisateur
      add(LoadUserTontinesEvent());
    } catch (e) {
      emit(TontineFailure(error: e.toString()));
    }
  }
}
