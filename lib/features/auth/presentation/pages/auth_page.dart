import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

import 'login_page.dart';

/// AuthScreen Scaffold class
class AuthScreen extends StatelessWidget {
  /// AuthScreen Scaffold class constructor

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dreamFlutterStarterKit),
      ),
      body: const LoginPage(),
    );
  }
}
