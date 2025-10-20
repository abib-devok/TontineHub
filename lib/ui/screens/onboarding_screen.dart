import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Importer le package TTS
import 'package:tontine_hub/bloc/auth/auth_bloc.dart';
import 'package:tontine_hub/bloc/auth/auth_event.dart';
import 'package:tontine_hub/ui/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Instance de FlutterTts
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _setupTts();
  }

  // Configuration de la langue pour TTS
  Future<void> _setupTts() async {
    await _flutterTts.setLanguage("fr-FR"); // Langue par défaut
    // Pour le wolof, il faudrait un moteur TTS qui le supporte.
    // "fr-FR" est utilisé ici comme substitut.
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(RegisterEvent(
            phone: _phoneController.text,
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Text(
                  "Bienvenue sur TontineHub",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Créez un compte pour commencer à gérer vos tontines.",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Bouton pour la lecture vocale
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      tooltip: "Écouter les instructions",
                      onPressed: () => _speak(
                        "Bienvenue sur Tontine Hub. "
                        "Veuillez entrer votre numéro de téléphone, puis un mot de passe à huit caractères. "
                        "Confirmez votre mot de passe et appuyez sur s'inscrire."
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Numéro de téléphone (+221)'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || !RegExp(r'^\+221[0-9]{9}$').hasMatch(value)
                      ? 'Veuillez entrer un numéro valide'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (value) => value == null || value.length < 8
                      ? 'Le mot de passe doit faire au moins 8 caractères'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                  validator: (value) => value != _passwordController.text
                      ? 'Les mots de passe ne correspondent pas'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("S'inscrire"),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginScreen())
                  ),
                  child: const Text("Déjà un compte ? Connectez-vous"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
