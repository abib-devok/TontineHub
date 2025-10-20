// Mock Paiements - simulation aléatoire insistée
class MockPaymentService {
  Future<Map<String, dynamic>> processPayment(
      double amount, String provider) async {
    await Future.delayed(Duration(seconds: 1)); // Delay réaliste
    bool success =
        DateTime.now().millisecond % 10 > 3; // 70% succès
    if (success) {
      print('Paiement mock succès : $amount CFA via $provider');
      return {
        'status': 'succès',
        'id': 'mock_tx_${DateTime.now().millisecondsSinceEpoch}'
      };
    }
    throw Exception('Échec mock : Fonds insuffisants');
  }
}
