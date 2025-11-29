// import 'package:ai_chat/app/app_route.dart';
// import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/app_settings/presentation/pages/setting_page.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/features/auth/domain/user_role.dart';
import 'package:ai_chat/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/login_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/otp_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/phone_number_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/signup_page.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/features/home/presentation/layout/home_layout.dart';
import 'package:ai_chat/features/home/presentation/pages/home_page.dart';
import 'package:ai_chat/features/home/presentation/pages/second_page.dart';
import 'package:ai_chat/features/home/presentation/pages/third_page.dart';
import 'package:ai_chat/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A helper class to bridge Riverpod's StateNotifier to a ChangeNotifier.
/// This allows GoRouter's `refreshListenable` to react to changes in the
/// authentication state.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AuthListenable extends ChangeNotifier {
  final Ref ref;
  ProviderSubscription<AuthState>? _subscription;

  AuthListenable(this.ref) {
    _subscription =
        ref.listen<AuthState>(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}

final initializationFutureProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
});
final Map<String, List<UserRole>> routeAllowedRoles = {
  '/home': [UserRole.authenticatedUser, UserRole.admin],
  '/settings': [UserRole.authenticatedUser, UserRole.admin],
  '/login': [UserRole.guest],
  '/register': [UserRole.guest],
  // Add all your routes here with their allowed roles
};
final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthListenable(ref);

  ref.onDispose(() {
    authListenable.dispose();
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authListenable,
    routes: [
      /// Shell route for persistent HomeLayout with IndexedStack
      ShellRoute(
        builder: (context, state, child) {
          return HomeLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/secondBottomNav',
            name: 'secondBottomNav',
            builder: (context, state) => const SecondPage(),
          ),
          GoRoute(
            path: '/thirdBottomNav',
            name: 'thirdBottomNav',
            builder: (context, state) => const ThirdPage(),
          ),
        ],
      ),
      // Top-level route for settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/phone-number',
        name: 'phone-number',
        builder: (context, state) => const PhoneNumberPage(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OTPPage(),
      ),
      GoRoute(
        path: '/forget_password',
        name: 'forget_password',
        builder: (context, state) => const ForgetPassword(),
      ),

      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreenWidget(),
      ),
    ],
    redirect: (context, state) {
      final isInitialized = ref.watch(initializationFutureProvider).hasValue;
      if (!isInitialized) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final authState = ref.read(authControllerProvider);
      final isAuthenticated = authState is Authenticated;

      final isAuthRoute = [
        '/login',
        '/register',
        '/phone-number',
        '/otp',
        '/forget_password',
      ].contains(state.matchedLocation);
      if (state.matchedLocation == '/splash') {
        return isAuthenticated ? '/home' : '/login';
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
  );
});
