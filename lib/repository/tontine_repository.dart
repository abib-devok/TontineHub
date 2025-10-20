import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tontine_model.dart';

const bool DEV_MODE = true;

class TontineRepository {
  final SupabaseClient _supabaseClient;

  TontineRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  Future<TontineModel> createTontine({
    required String name,
    required Map<String, dynamic> rules,
  }) async {
    if (DEV_MODE) {
      print('Création de la tontine mock: $name');
      return TontineModel(
        id: 'mock_tontine_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        rulesJson: rules,
        ownerId: 'mock_user_id',
      );
    } else {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final response = await _supabaseClient
          .from('tontines')
          .insert({
            'name': name,
            'rules_json': rules,
            'owner_id': user.id,
          })
          .select()
          .single();

      // Ajouter automatiquement le créateur comme membre
      await joinTontine(response['id']);

      return TontineModel.fromJson(response);
    }
  }

  Future<List<TontineModel>> getUserTontines() async {
    if (DEV_MODE) {
      return [
        TontineModel(id: 'mock_tontine_1', name: 'Tontine de Test 1', ownerId: 'mock_user_id', rulesJson: {'montant': 5000}),
        TontineModel(id: 'mock_tontine_2', name: 'Tontine de Test 2', ownerId: 'mock_user_id', rulesJson: {'montant': 10000}),
      ];
    } else {
      final response = await _supabaseClient.rpc('get_user_tontines');

      return (response as List)
          .map((tontine) => TontineModel.fromJson(tontine))
          .toList();
    }
  }

  Future<void> joinTontine(String tontineId) async {
    if (DEV_MODE) {
      print('Utilisateur a rejoint la tontine mock: $tontineId');
      return;
    } else {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non authentifié');

      await _supabaseClient.from('tontine_members').insert({
        'tontine_id': tontineId,
        'user_id': user.id,
      });
    }
  }

  Future<void> leaveTontine(String tontineId) async {
    if (DEV_MODE) {
      print('Utilisateur a quitté la tontine mock: $tontineId');
      return;
    } else {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non authentifié');

      await _supabaseClient
          .from('tontine_members')
          .delete()
          .match({'tontine_id': tontineId, 'user_id': user.id});
    }
  }
}
