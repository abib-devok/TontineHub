import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importer le package
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tontine_hub/core/theme/app_theme.dart';
import 'package:tontine_hub/l10n/app_localizations.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/payment/payment_bloc.dart';
import 'bloc/tontine/tontine_bloc.dart';
import 'repository/auth_repository.dart';
import 'repository/payment_repository.dart';
import 'repository/tontine_repository.dart';
import 'ui/screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Initialiser Supabase avec les variables d'environnement
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    final TontineRepository tontineRepository = TontineRepository();
    final PaymentRepository paymentRepository = PaymentRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: tontineRepository),
        RepositoryProvider.value(value: paymentRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider<TontineBloc>(
            create: (context) => TontineBloc(tontineRepository: tontineRepository),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(paymentRepository: paymentRepository),
          ),
        ],
        child: MaterialApp(
          title: 'TontineHub',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthWrapper(),
        ),
      ),
    );
  }
}
