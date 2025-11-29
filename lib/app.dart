import 'package:ai_chat/app/router.dart';
import 'package:ai_chat/app/theme/app_theme.dart';
import 'package:ai_chat/features/app_settings/provider/settings_provider.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App is Main material app which called to main and assigned themes router configuration and debug show checked mode value
class App extends ConsumerWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'FlutterStarterKit',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.value?.themeMode ?? ThemeMode.light,
      locale: settings.value?.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('km'),
        Locale('ja'),
        Locale('es'),
      ],
      // supportedLocales: AppLocale.flutterSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the locale language code matches any supported locale
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        // Default to English if no match found
        return const Locale('en');
      },
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
