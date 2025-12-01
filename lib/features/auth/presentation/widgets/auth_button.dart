import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_state.dart';

class AuthButton extends ConsumerWidget {
  final AuthMethod authMethod;
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Widget? icon;
  final bool isPrimary;

  const AuthButton({
    super.key,
    required this.authMethod,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLoading =
        ref.watch(_currentAuthMethodProvider) == authMethod && isLoading;

    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton(
              onPressed: currentLoading ? null : onPressed,
              child: currentLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(text),
            )
          : OutlinedButton(
              onPressed: currentLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: currentLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 12),
                        ],
                        Text(
                          text,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
            ),
    );
  }
}

final _currentAuthMethodProvider =
    StateProvider<AuthMethod>((ref) => AuthMethod.none);
