import 'app_localizations.dart';

/// The translations for Wolof (`wo`).
class AppLocalizationsWo extends AppLocalizations {
  AppLocalizationsWo([String locale = 'wo']) : super(locale);

  @override
  String get welcomeMessage => 'Dalal ak jàmm ci TontineHub';

  @override
  String get createAccountPrompt => 'Ubbil kont ngir door a saytu say tontin.';

  @override
  String get phoneNumberHint => 'Sa nimero telefon (+221)';

  @override
  String get emailHint => 'Sa adaresu imel';

  @override
  String get passwordHint => 'Batu jàll';

  @override
  String get confirmPasswordHint => 'Dëggal batu jàll bi';

  @override
  String get registerButton => 'Bindu';

  @override
  String get alreadyHaveAccount => 'Am nga kont ba pare ? Boolu';
}
