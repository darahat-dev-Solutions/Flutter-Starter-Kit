import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

/// Second bottom navigation page
class SecondPage extends StatelessWidget {
  /// Constructor
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.secondPage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.chatAndMessages,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
