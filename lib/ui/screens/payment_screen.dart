import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/bloc/payment/payment_bloc.dart';
import 'package:tontine_hub/bloc/payment/payment_event.dart';
import 'package:tontine_hub/bloc/payment/payment_state.dart';

class PaymentScreen extends StatefulWidget {
  final String tontineId;
  final double amount;

  const PaymentScreen({
    Key? key,
    required this.tontineId,
    required this.amount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedProvider;
  final List<String> _providers = ['Wave', 'Orange Money', 'Free Money'];

  void _submitPayment() {
    if (_selectedProvider != null) {
      context.read<PaymentBloc>().add(MakePaymentEvent(
            tontineId: widget.tontineId,
            amount: widget.amount,
            provider: _selectedProvider!,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un fournisseur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Effectuer un Paiement"),
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paiement réussi !"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(); // Revenir à l'écran de détail
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Échec du paiement: ${state.error}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Montant à payer: ${widget.amount.toStringAsFixed(0)} CFA",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Sélection du fournisseur
              DropdownButtonFormField<String>(
                value: _selectedProvider,
                decoration: const InputDecoration(
                  labelText: 'Choisir un fournisseur',
                  border: OutlineInputBorder(),
                ),
                items: _providers.map((String provider) {
                  return DropdownMenuItem<String>(
                    value: provider,
                    child: Text(provider),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProvider = newValue;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Bouton de paiement
              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Payer maintenant"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
