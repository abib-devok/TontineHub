import 'package:flutter/material.dart';

class ProposalScreen extends StatelessWidget {
  final String tontineId;
  final String type; // "Modification" ou "Fusion"

  const ProposalScreen({
    Key? key,
    required this.tontineId,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proposer une $type"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Faire une proposition de $type pour la tontine $tontineId.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description de la proposition',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implémenter la logique de soumission de la proposition (événement BLoC)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Proposition soumise pour vote !"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Soumettre pour vote"),
            ),
          ],
        ),
      ),
    );
  }
}
