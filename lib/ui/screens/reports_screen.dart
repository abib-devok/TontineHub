import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Données de démonstration pour le graphique
    final data = [
      PaymentSeries(month: "Jan", amount: 20000),
      PaymentSeries(month: "Fév", amount: 25000),
      PaymentSeries(month: "Mar", amount: 22000),
      PaymentSeries(month: "Avr", amount: 28000),
    ];

    // Configuration de la série pour le graphique
    final series = [
      charts.Series(
        id: "Paiements",
        data: data,
        domainFn: (PaymentSeries series, _) => series.month,
        measureFn: (PaymentSeries series, _) => series.amount,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapports et Analyses"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Total des Contributions Mensuelles",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: charts.BarChart(
                series,
                animate: true,
              ),
            ),
             const SizedBox(height: 24),
            // D'autres statistiques pourraient être ajoutées ici
            Card(
              child: ListTile(
                leading: Icon(Icons.people, color: Theme.of(context).primaryColor),
                title: const Text("Membres Actifs"),
                trailing: Text("12", style: Theme.of(context).textTheme.headline6),
              ),
            ),
             Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: const Text("Taux de Paiement à Temps"),
                trailing: Text("95%", style: Theme.of(context).textTheme.headline6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Classe de modèle pour les données du graphique
class PaymentSeries {
  final String month;
  final int amount;

  PaymentSeries({required this.month, required this.amount});
}
