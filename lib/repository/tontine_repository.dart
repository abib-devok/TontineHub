import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tontine_model.dart';

const bool DEV_MODE = true;

class TontineRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

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

  // Nouvelle méthode pour quitter une tontine
  Future<void> leaveTontine(String tontineId) async {
    if (DEV_MODE) {
      print('L\'utilisateur a quitté la tontine mock: $tontineId');
      // Simule une opération réussie
      return;
    } else {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non authentifié');
      }
      // La logique réelle impliquerait de retirer l'utilisateur de la table des membres
      // Pour cet exemple, nous simulons simplement une opération.
      print('Logique de suppression de la tontine $tontineId pour l\'utilisateur ${user.id} à implémenter.');
    }
  }
}
