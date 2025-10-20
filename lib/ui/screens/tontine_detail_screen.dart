import 'package:flutter/material.dart';
import 'package.flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/bloc/payment/payment_bloc.dart';
import 'package:tontine_hub/bloc/payment/payment_event.dart';
import 'package:tontine_hub/bloc/payment/payment_state.dart';
import 'package:tontine_hub/bloc/tontine/tontine_bloc.dart';
import 'package:tontine_hub/bloc/tontine/tontine_event.dart';
import 'package:tontine_hub/bloc/tontine/tontine_state.dart';
import 'package:tontine_hub/models/tontine_model.dart';
import 'package:tontine_hub/ui/screens/payment_screen.dart';
import 'package:tontine_hub/ui/screens/proposal_screen.dart'; // Écran de proposition générique

class TontineDetailScreen extends StatefulWidget {
  final TontineModel tontine;

  const TontineDetailScreen({Key? key, required this.tontine}) : super(key: key);

  @override
  _TontineDetailScreenState createState() => _TontineDetailScreenState();
}

class _TontineDetailScreenState extends State<TontineDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(LoadTontinePaymentsEvent(tontineId: widget.tontine.id));
  }

  void _showLeaveTontineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Quitter la Tontine"),
          content: const Text("Êtes-vous sûr de vouloir quitter cette tontine ?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Quitter", style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Déclencher l'événement pour quitter la tontine
                context.read<TontineBloc>().add(LeaveTontineEvent(tontineId: widget.tontine.id));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TontineBloc, TontineState>(
      listener: (context, state) {
        if (state is TontineLeft) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vous avez quitté la tontine avec succès."), backgroundColor: Colors.green),
          );
          // Revenir au tableau de bord après avoir quitté
          Navigator.of(context).pop();
        } else if (state is TontineFailure) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: ${state.error}"), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tontine.name),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Règles", style: Theme.of(context).textTheme.titleLarge),
              Card(
                child: ListTile(
                  title: Text("Montant: ${widget.tontine.rulesJson?['montant'] ?? 'N/A'} CFA"),
                  subtitle: Text("Fréquence: ${widget.tontine.rulesJson?['frequence'] ?? 'N/A'}"),
                ),
              ),
              const SizedBox(height: 24),

              Text("Gestion", style: Theme.of(context).textTheme.titleLarge),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text("Proposer une modification"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProposalScreen(tontineId: widget.tontine.id, type: "Modification")
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.merge_type),
                      title: const Text("Proposer une fusion"),
                      onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProposalScreen(tontineId: widget.tontine.id, type: "Fusion")
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app, color: Colors.red),
                      title: const Text("Quitter la tontine", style: TextStyle(color: Colors.red)),
                      onTap: _showLeaveTontineDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text("Paiements", style: Theme.of(context).textTheme.titleLarge),
              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentsLoaded) {
                     if (state.payments.isEmpty) return const Text("Aucun paiement.");
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.payments.length,
                      itemBuilder: (context, index) {
                        final payment = state.payments[index];
                        return Card(
                          child: ListTile(
                            title: Text("Montant: ${payment.amount} CFA"),
                            trailing: Icon(
                              payment.status == PaymentStatus.success ? Icons.check_circle : Icons.cancel,
                              color: payment.status == PaymentStatus.success ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                    );
                  }
                   return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentScreen(tontineId: widget.tontine.id, amount: (widget.tontine.rulesJson?['montant'] as num).toDouble()),
              ),
            );
          },
          label: const Text("Payer"),
          icon: const Icon(Icons.payment),
        ),
      ),
    );
  }
}
