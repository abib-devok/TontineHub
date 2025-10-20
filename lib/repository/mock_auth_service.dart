import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importer User

// Mock Auth - simulation avec retour d'un User factice
class MockAuthService {
  final Map<String, String> _users = {}; // phone -> hashedPassword

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = SHA256Digest().process(Uint8List.fromList(bytes));
    return base64.encode(digest);
  }

  Future<User?> register(String phone, String password) async {
    if (_users.containsKey(phone)) {
      throw Exception('Numéro déjà utilisé');
    }
    _users[phone] = _hashPassword(password);
    print('Inscription mock pour $phone');
    // Retourne un User factice pour la cohérence
    return User(
      id: 'mock_user_${phone.hashCode}',
      appMetadata: {},
      userMetadata: {'phone': phone},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Future<User?> login(String phone, String password) async {
    final hashedPassword = _hashPassword(password);
    if (!_users.containsKey(phone) || _users[phone] != hashedPassword) {
      throw Exception('Credentials invalides');
    }
    print('Connexion mock réussie pour $phone');
    // Retourne un User factice pour la cohérence
    return User(
      id: 'mock_user_${phone.hashCode}',
      appMetadata: {},
      userMetadata: {'phone': phone},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}
