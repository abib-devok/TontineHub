import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  void initialize() {
    // Écouter les insertions dans la table 'payments'
    _supabaseClient
        .channel('public:payments')
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(event: 'INSERT', schema: 'public', table: 'payments'),
          (payload, [ref]) {
            _handlePaymentNotification(payload);
          },
        )
        .subscribe();
  }

  void _handlePaymentNotification(Map<String, dynamic> payload) {
    // Dans une application réelle, on utiliserait un package comme flutter_local_notifications
    // pour afficher une notification au premier plan.
    // Ici, nous simulons cela en imprimant dans la console.

    final newPayment = payload['new'];
    final tontineId = newPayment['tontine_id'];
    final amount = newPayment['amount'];

    print('🔔 NOUVELLE NOTIFICATION 🔔');
    print('Un nouveau paiement de $amount CFA a été effectué dans la tontine $tontineId.');
  }

  void dispose() {
    _supabaseClient.removeAllChannels();
  }
}
