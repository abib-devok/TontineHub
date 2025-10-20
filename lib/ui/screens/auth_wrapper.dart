import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/services/notification_service.dart'; // Importer le service
import 'package:tontine_hub/ui/screens/dashboard_screen.dart';
import 'package:tontine_hub/ui/screens/onboarding_screen.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  NotificationService? _notificationService;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Initialiser le service de notification après une connexion réussie
          _notificationService = NotificationService();
          _notificationService!.initialize();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connecté avec succès !'), backgroundColor: Colors.green),
          );
        } else if (state is AuthInitial) {
          // Arrêter le service lors de la déconnexion
          _notificationService?.dispose();
          _notificationService = null;
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return DashboardScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return OnboardingScreen();
        }
      },
    );
  }
}
