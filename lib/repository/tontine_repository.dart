import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tontine_model.dart';

// Mettre à `true` pour utiliser les mocks, `false` pour l'API Supabase réelle.
const bool DEV_MODE = true;

class TontineRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<TontineModel> createTontine({
    required String name,
    required Map<String, dynamic> rules,
  }) async {
    if (DEV_MODE) {
      // Simulation de la création d'une tontine en mode mock
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

      return TontineModel.fromJson(response);
    }
  }

  Future<List<TontineModel>> getUserTontines() async {
    if (DEV_MODE) {
      // Retourne une liste de tontines mock
      return [
        TontineModel(id: 'mock_tontine_1', name: 'Tontine de Test 1', ownerId: 'mock_user_id'),
        TontineModel(id: 'mock_tontine_2', name: 'Tontine de Test 2', ownerId: 'mock_user_id'),
      ];
    } else {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final response = await _supabaseClient
          .from('tontines')
          .select()
          .eq('owner_id', user.id);

      return (response as List)
          .map((tontine) => TontineModel.fromJson(tontine))
          .toList();
    }
  }
}
