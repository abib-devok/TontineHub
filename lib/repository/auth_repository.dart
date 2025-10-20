import 'package:supabase_flutter/supabase_flutter.dart';
import 'mock_auth_service.dart';

// Mettre à `true` pour utiliser les mocks, `false` pour l'API Supabase réelle.
const bool DEV_MODE = true;

class AuthRepository {
  final SupabaseClient _supabaseClient;
  final MockAuthService _mockAuthService = MockAuthService();

  // Le client est maintenant injectable pour faciliter les tests.
  AuthRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  Future<User?> register({
    required String phone,
    required String password,
  }) async {
    if (DEV_MODE) {
      await _mockAuthService.register(phone, password);
      // Le mock ne retourne pas d'objet User, donc on retourne null en mode dev.
      return null;
    } else {
      // Utilisation du téléphone pour l'inscription, avec un e-mail factice car requis par Supabase.
      final String dummyEmail = '$phone@tontinehub.app';
      final response = await _supabaseClient.auth.signUp(
        email: dummyEmail, // Supabase requiert un email, nous en créons un factice.
        password: password,
        phone: phone,
      );
      return response.user;
    }
  }

  Future<User?> login({
    required String phone,
    required String password,
  }) async {
    if (DEV_MODE) {
      await _mockAuthService.login(phone, password);
      return null;
    } else {
      final response = await _supabaseClient.auth.signInWithPassword(
        phone: phone, // Utilisation du téléphone pour la connexion.
        password: password,
      );
      return response.user;
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
