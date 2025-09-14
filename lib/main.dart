import 'package:ecoroute/core/utils/themes/dark_theme.dart';
import 'package:ecoroute/core/utils/themes/light_theme.dart';
import 'package:ecoroute/dependency_injection.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/view_models/favorite_view_model.dart';
import 'package:ecoroute/view_models/location_view_model.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:ecoroute/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await SentryFlutter.init(
    (options) => options.dsn = dotenv
        .env['SENTRY_DNS'], // burası değiştirildi.. öncesinde böyleydi :  SentryFlutterOptions(dsn: dotenv.env['SENTRY_DNS']
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => sl.get<AuthViewModel>()),
          ChangeNotifierProvider(create: (context) => sl.get<MainViewModel>()),
          ChangeNotifierProvider(
            create: (context) => sl.get<LocationViewModel>(),
          ),
          ChangeNotifierProvider(
            create: (context) => sl.get<FavoriteViewModel>(),
          ),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      theme: lightTheme,
      themeMode: context.watch<MainViewModel>().theme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(context.watch<MainViewModel>().language.name),
    );
  }
}
