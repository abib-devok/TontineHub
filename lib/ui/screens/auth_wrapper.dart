import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/ui/screens/dashboard_screen.dart';
import 'package:tontine_hub/ui/screens/onboarding_screen.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';


class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Écoute les changements d'état du AuthBloc
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Peut être utilisé pour afficher des SnackBars ou naviguer
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        // Affiche l'écran approprié en fonction de l'état
        if (state is AuthSuccess) {
          // Si l'utilisateur est connecté, affiche le tableau de bord
          return DashboardScreen();
        } else if (state is AuthLoading) {
          // Affiche un indicateur de chargement
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          // Sinon, affiche l'écran de bienvenue/inscription
          return OnboardingScreen();
        }
      },
    );
  }
}
