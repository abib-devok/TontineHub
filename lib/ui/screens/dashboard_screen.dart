import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/bloc/auth/auth_bloc.dart';
import 'package:tontine_hub/bloc/auth/auth_event.dart';
import 'package:tontine_hub/bloc/tontine/tontine_bloc.dart';
import 'package:tontine_hub/bloc/tontine/tontine_event.dart';
import 'package:tontine_hub/bloc/tontine/tontine_state.dart';
import 'package:tontine_hub/ui/screens/create_tontine_screen.dart'; // Placeholder

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les tontines de l'utilisateur au démarrage de l'écran
    context.read<TontineBloc>().add(LoadUserTontinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déclencher l'événement de déconnexion
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TontineBloc, TontineState>(
        builder: (context, state) {
          if (state is TontineLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TontinesLoaded) {
            if (state.tontines.isEmpty) {
              return const Center(child: Text("Vous n'avez pas encore de tontine."));
            }
            // Afficher la liste des tontines
            return ListView.builder(
              itemCount: state.tontines.length,
              itemBuilder: (context, index) {
                final tontine = state.tontines[index];
                return ListTile(
                  title: Text(tontine.name),
                  subtitle: Text("Propriétaire: ${tontine.ownerId}"), // À améliorer
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Naviguer vers les détails de la tontine
                  },
                );
              },
            );
          } else if (state is TontineFailure) {
            return Center(child: Text("Erreur: ${state.error}"));
          } else {
            return const Center(child: Text("Bienvenue !"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateTontineScreen())
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Créer une tontine',
      ),
    );
  }
}
