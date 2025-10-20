import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';

// Mock Auth - simulation inscription/connexion avec hashing réel
class MockAuthService {
  final Map<String, String> _users = {}; // Simule la DB: phone -> hashedPassword

  // Fonction pour hasher le mot de passe avec SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convertir le mot de passe en bytes
    var digest = SHA256Digest().process(Uint8List.fromList(bytes));
    return base64.encode(digest); // Retourner le hash en format base64
  }

  Future<bool> register(String phone, String password) async {
    if (_users.containsKey(phone)) {
      throw Exception('Numéro déjà utilisé');
    }
    _users[phone] = _hashPassword(password); // Stocker le hash
    print('Inscription mock pour $phone (hash: ${_users[phone]})'); // Log audit
    return true;
  }

  Future<String> login(String phone, String password) async {
    final hashedPassword = _hashPassword(password);
    if (!_users.containsKey(phone) || _users[phone] != hashedPassword) {
      throw Exception('Credentials invalides');
    }
    print('Connexion mock réussie pour $phone');
    return 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}'; // Simuler un token JWT unique
  }
}
