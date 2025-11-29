import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Third bottom navigation page
class ThirdPage extends StatelessWidget {
  /// Constructor
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.thirdPage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.aiChatAssistant,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
