import 'package:flutter/material.dart';
import 'package:tontine_hub/ui/screens/premium_screen.dart'; // Importer l'écran premium

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String userPhone = "+221 77 123 45 67";
    const double confianceScore = 120;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text("Numéro de téléphone"),
                      subtitle: Text(userPhone),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.shield, color: Theme.of(context).primaryColor),
                      title: const Text("Score de Confiance"),
                      trailing: Text(
                        confianceScore.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Bouton pour passer au premium
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PremiumScreen()),
                );
              },
              icon: const Icon(Icons.star),
              label: const Text("Passer au Premium"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
