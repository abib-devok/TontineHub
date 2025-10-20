import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';
import 'mock_payment_service.dart';

// Mettre à `true` pour utiliser les mocks, `false` pour l'API Supabase réelle.
const bool DEV_MODE = true;

class PaymentRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final MockPaymentService _mockPaymentService = MockPaymentService();

  Future<PaymentModel> makePayment({
    required String tontineId,
    required double amount,
    required String provider, // 'Wave', 'Orange Money', etc.
  }) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null && !DEV_MODE) {
      throw Exception('Utilisateur non authentifié');
    }

    final userId = DEV_MODE ? 'mock_user_id' : user!.id;

    if (DEV_MODE) {
      final mockResponse = await _mockPaymentService.processPayment(amount, provider);
      return PaymentModel(
        id: mockResponse['id'],
        tontineId: tontineId,
        userId: userId,
        amount: amount,
        status: PaymentStatus.success, // Le mock ne simule que le succès ici
      );
    } else {
      // Intégration avec un vrai service de paiement (ex: Flutterwave)
      // ... (logique d'appel à l'API de paiement)

      // Pour cet exemple, on insère directement un paiement réussi dans Supabase
      final response = await _supabaseClient
          .from('payments')
          .insert({
            'tontine_id': tontineId,
            'user_id': userId,
            'amount': amount,
            'status': 'success',
          })
          .select()
          .single();

      return PaymentModel.fromJson(response);
    }
  }

  Future<List<PaymentModel>> getTontinePayments(String tontineId) async {
    if (DEV_MODE) {
      // Retourne une liste de paiements mock
      return [
        PaymentModel(id: 'mock_payment_1', tontineId: tontineId, userId: 'mock_user_1', amount: 5000, status: PaymentStatus.success),
        PaymentModel(id: 'mock_payment_2', tontineId: tontineId, userId: 'mock_user_2', amount: 5000, status: PaymentStatus.success),
      ];
    } else {
      final response = await _supabaseClient
          .from('payments')
          .select()
          .eq('tontine_id', tontineId);

      return (response as List)
          .map((payment) => PaymentModel.fromJson(payment))
          .toList();
    }
  }
}
