import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/services/hive_service.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';

import '../application/auth_controller.dart';
import '../application/auth_state.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_in_with_github_usecase.dart';
import '../domain/usecases/sign_in_with_google_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../infrastructure/auth_repository.dart';

/// Repository provider - carries all functionality of AuthRepository model functions.
final authRepositoryProvider = Provider((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final logger = ref.watch(appLoggerProvider);
  return AuthRepository(hiveService, logger);
});

/// Use case providers
final signInUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signUpUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final signInWithGoogleUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithGoogleUseCase(repository);
});

final signInWithGithubUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithGithubUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final signOutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

/// authStateProvider will check users recent status and carries User information.
/// AuthStateProvider will use for all kind of calling in controller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authBox = ref.watch(hiveServiceProvider).authBox;
    final signInUseCase = ref.watch(signInUseCaseProvider);
    final signUpUseCase = ref.watch(signUpUseCaseProvider);
    final signInWithGoogleUseCase = ref.watch(signInWithGoogleUseCaseProvider);
    final signInWithGithubUseCase = ref.watch(signInWithGithubUseCaseProvider);
    final forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
    final signOutUseCase = ref.watch(signOutUseCaseProvider);
    final logger = ref.watch(appLoggerProvider);
    final authRepository = ref.watch(authRepositoryProvider);

    return AuthController(
      authBox,
      ref,
      logger,
      signInUseCase,
      signUpUseCase,
      signInWithGoogleUseCase,
      signInWithGithubUseCase,
      forgotPasswordUseCase,
      signOutUseCase,
      authRepository,
    );
  },
);

/// Obscure text provider which will be use in login and signup
final obscureTextProvider = StateProvider<bool>((ref) => true);
