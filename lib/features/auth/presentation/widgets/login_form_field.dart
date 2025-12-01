import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_providers.dart';

class LoginFormField extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool showObscureToggle;

  const LoginFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.showObscureToggle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscureTextState =
        showObscureToggle ? ref.watch(obscureTextProvider) : obscureText;

    return TextFormField(
      controller: controller,
      obscureText: obscureTextState,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon: showObscureToggle
            ? IconButton(
                icon: Icon(
                  obscureTextState
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  ref.read(obscureTextProvider.notifier).state =
                      !obscureTextState;
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      autocorrect: false,
    );
  }
}
