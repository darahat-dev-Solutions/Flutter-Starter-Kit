import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/widgets/scaffold_messenger.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_controller.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_state.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../provider/auth_providers.dart';
import '../widgets/auth_button.dart' hide AuthMethod;
import '../widgets/login_form_field.dart';
import '../widgets/login_header.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        ref.read(_currentAuthMethodProvider.notifier).state = AuthMethod.none;
        scaffoldMessenger(context, next);
      }
      if (next is Authenticated) {
        ref.read(_currentAuthMethodProvider.notifier).state = AuthMethod.none;
        context.go('/home', extra: {'title': 'Home'});
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoginHeader(),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        LoginFormField(
                          controller: _emailController,
                          labelText: l10n.email,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterYourEmail;
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return l10n.pleaseEnterAValidEmailAddress;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        LoginFormField(
                          controller: _passwordController,
                          labelText: l10n.password,
                          prefixIcon: Icons.lock_outline,
                          showObscureToggle: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterYourPassword;
                            }
                            if (value.length < 6) {
                              return l10n.passwordMustBeAtLeast6Characters;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Links
                        _buildLinksSection(context, l10n, isLoading),
                        const SizedBox(height: 24),

                        // Email Sign In Button
                        AuthButton(
                          authMethod: AuthMethod.email,
                          isLoading: isLoading,
                          onPressed: () => _handleEmailSignIn(controller),
                          text: l10n.signIn,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  _buildDivider(context, l10n),
                  const SizedBox(height: 24),

                  // Social Auth Buttons
                  _buildSocialAuthSection(context, l10n, controller, isLoading),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Loading Overlay
            if (isLoading) _buildLoadingOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(
      BuildContext context, AppLocalizations l10n, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextButton(
            onPressed: isLoading ? null : () => context.go('/register'),
            child: Text.rich(
              TextSpan(
                text: '${l10n.dontHaveAnAccount} ',
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: l10n.signUp,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: isLoading ? null : () => context.go('/forget_password'),
            child: Text(
              l10n.forgotPassword,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.or,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialAuthSection(
    BuildContext context,
    AppLocalizations l10n,
    AuthController controller,
    bool isLoading,
  ) {
    return Column(
      children: [
        // Google
        AuthButton(
          authMethod: AuthMethod.google,
          isLoading: isLoading,
          onPressed: () async {
            ref.read(_currentAuthMethodProvider.notifier).state =
                AuthMethod.google;
            await controller.signInWithGoogle();
          },
          text: l10n.continueWithGoogle,
          icon: Image.asset(
            'assets/icon/google_logo.png',
            height: 24,
            width: 24,
          ),
        ),
        const SizedBox(height: 16),

        // Phone
        OutlinedButton(
          onPressed: isLoading ? null : () => context.go('/phone-number'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.continueWithPhone,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // GitHub
        AuthButton(
          authMethod: AuthMethod.github,
          isLoading: isLoading,
          onPressed: () async {
            ref.read(_currentAuthMethodProvider.notifier).state =
                AuthMethod.github;
            await controller.signInWithGithub();
          },
          text: l10n.continueWithGithub,
          icon: Image.asset(
            'assets/icon/github_logo.png',
            height: 24,
            width: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _handleEmailSignIn(AuthController controller) {
    if (_formKey.currentState!.validate()) {
      ref.read(_currentAuthMethodProvider.notifier).state = AuthMethod.email;
      controller.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }
}

final _currentAuthMethodProvider =
    StateProvider<AuthMethod>((ref) => AuthMethod.none);
