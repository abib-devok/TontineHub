import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tontine_hub/bloc/tontine/tontine_bloc.dart';
import 'package:tontine_hub/bloc/tontine/tontine_event.dart';
import 'package:tontine_hub/bloc/tontine/tontine_state.dart';

class CreateTontineScreen extends StatefulWidget {
  @override
  _CreateTontineScreenState createState() => _CreateTontineScreenState();
}

class _CreateTontineScreenState extends State<CreateTontineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  double _contributionAmount = 5000;
  String _frequency = 'Mensuel';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<TontineBloc>().add(CreateTontineEvent(
            name: _nameController.text,
            rules: {
              'montant': _contributionAmount,
              'frequence': _frequency,
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une Tontine"),
      ),
      body: BlocListener<TontineBloc, TontineState>(
        listener: (context, state) {
          if (state is TontineCreated) {
            // Revenir à l'écran précédent et rafraîchir la liste
            Navigator.of(context).pop();
            context.read<TontineBloc>().add(LoadUserTontinesEvent());
          } else if (state is TontineFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur: ${state.error}")),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la tontine',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Slider pour le montant
                Text("Montant de la contribution: ${_contributionAmount.toStringAsFixed(0)} CFA"),
                Slider(
                  value: _contributionAmount,
                  min: 1000,
                  max: 50000,
                  divisions: 49,
                  label: _contributionAmount.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _contributionAmount = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Dropdown pour la fréquence
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: const InputDecoration(
                    labelText: 'Fréquence de paiement',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Hebdomadaire', 'Mensuel', 'Trimestriel']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _frequency = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Bouton de création
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Créer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
