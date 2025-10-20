import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeMessage => 'Bienvenue sur TontineHub';

  @override
  String get createAccountPrompt => 'Créez un compte pour commencer à gérer vos tontines.';

  @override
  String get phoneNumberHint => 'Numéro de téléphone (+221)';

  @override
  String get emailHint => 'Adresse e-mail';

  @override
  String get passwordHint => 'Mot de passe';

  @override
  String get confirmPasswordHint => 'Confirmer le mot de passe';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Connectez-vous';
}
