import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:hive/hive.dart';

import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_in_with_github_usecase.dart';
import '../domain/usecases/sign_in_with_google_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../domain/user_model.dart';
import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

/// A controller class which manages user authentication using Clean Architecture with UseCases
class AuthController extends StateNotifier<AuthState> {
  /// Required instances
  final Box<UserModel> _authBox;
  final AuthRepository _authRepository;

  /// Use cases
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithGithubUseCase _signInWithGithubUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SignOutUseCase _signOutUseCase;

  /// Required references and variables
  final Ref ref;
  String? _verificationId;
  String? _phoneNumber;
  final AppLogger _appLogger;

  /// AuthController Constructor
  AuthController(
    this._authBox,
    this.ref,
    this._appLogger,
    this._signInUseCase,
    this._signUpUseCase,
    this._signInWithGoogleUseCase,
    this._signInWithGithubUseCase,
    this._forgotPasswordUseCase,
    this._signOutUseCase,
    this._authRepository,
  ) : super(const AuthInitial());

  /// Check User is Authenticated need to call in main to check
  void checkInitialAuthState() async {
    final getOnlineUser = await _authRepository.getCurrentUser();
    // Prefer the online Firebase user, otherwise fall back to locally stored user in Hive
    final localUser = _authBox.get('user');

    if (getOnlineUser != null) {
      _appLogger.debug('Online user found: ${getOnlineUser.displayName}');
      state = Authenticated(getOnlineUser);
      return;
    }

    if (localUser != null) {
      _appLogger.debug(
          'Using local user from Hive: ${localUser.displayName ?? localUser.uid}');
      state = Authenticated(localUser);
      return;
    }

    _appLogger.debug('No authenticated user found. Staying unauthenticated.');
    state = const AuthInitial();
  }

  /// Maintain Email & Password SignUp
  Future<void> signUp(String email, String password, String name) async {
    state = const AuthLoading();

    final result = await _signUpUseCase.call(
      SignUpParams(email: email, password: password, name: name),
    );

    result.fold(
      (failure) => state = AuthError(failure.message, AuthMethod.signup),
      (user) => state = Authenticated(user),
    );
  }

  /// Maintain Email & Password SignIn
  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();

    final result = await _signInUseCase.call(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = AuthError(failure.message, AuthMethod.email),
      (user) => state = Authenticated(user),
    );
  }

  /// Maintain Google SignIn
  Future<void> signInWithGoogle() async {
    state = const AuthLoading();

    final result = await _signInWithGoogleUseCase.call(const NoParams());

    result.fold(
      (failure) => state = AuthError(failure.message, AuthMethod.google),
      (user) {
        state = Authenticated(user);
        _appLogger.debug('Google sign in successful: ${user.displayName}');
      },
    );
  }

  /// Maintain Github SignIn
  Future<void> signInWithGithub() async {
    state = const AuthLoading();

    final result = await _signInWithGithubUseCase.call(const NoParams());

    result.fold(
      (failure) => state = AuthError(failure.message, AuthMethod.github),
      (user) {
        state = Authenticated(user);
        _appLogger.debug('Github sign in successful: ${user.displayName}');
      },
    );
  }

  /// Send Forget Password reset mail
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AuthLoading();

    final result = await _forgotPasswordUseCase.call(
      ForgotPasswordParams(email: email),
    );

    result.fold(
      (failure) => state = AuthError(failure.message, AuthMethod.email),
      (_) {
        state = const PasswordResetEmailSent();
        Future.delayed(
          const Duration(seconds: 1),
          () => state = const AuthInitial(),
        );
      },
    );
  }

  ///Maintain Sign out
  Future<void> signOut() async {
    state = const AuthLoading();

    final result = await _signOutUseCase.call(const NoParams());

    result.fold(
      (failure) {
        _appLogger.error('Sign out failed: ${failure.message}');
        state = AuthError(failure.message, AuthMethod.none);
      },
      (_) {
        state = const AuthInitial();
        _appLogger.debug('Sign out successful');
      },
    );
  }

  /// Maintain Phone authentication Sending OTP
  Future<void> sendOTP(String phoneNumber) async {
    // state = const AuthLoading();
    // state = const AuthLoading();
    _appLogger.debug(
      '🚀 ~ Trying to send OTP from auth controller $phoneNumber',
    );

    try {
      await _authRepository.sendOTP(
        phoneNumber,
        codeSent: (verificationId, resendToken) {
          _appLogger.debug(
            '🚀 ~ Trying to send OTP 1 from auth controller from co d sent start $verificationId , $resendToken',
          );

          _verificationId = verificationId;
          state = const OTPSent();
          _appLogger.debug(
            '🚀 ~ what is the state after cod sent $_verificationId , $state',
          );
        },
      );
      _appLogger.debug('🚀 ~ Trying to send OTP from auth controller');
    } catch (e) {
      _appLogger.debug('🚀 ~ send OTP failed from auth controller');
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }

  /// Maintain Phone authentication verify OTP
  Future<void> verifyOTP(String smsCode) async {
    state = const AuthLoading();
    try {
      if (_verificationId == null) {
        throw Exception('Verification ID is null. Please resend OTP.');
      }
      final user = await _authRepository.verifyOTP(_verificationId!, smsCode);
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = const AuthError('OTP verification failed', AuthMethod.phone);
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }

  /// Maintain Resend Phone authentication if send OTP failed

  Future<void> resendOTP() async {
    state = const AuthLoading();
    try {
      if (_phoneNumber == null) {
        throw Exception('Phone number is null. Please go back and re-enter.');
      }
      await _authRepository.resendOTP(
        _phoneNumber!,
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          state = const OTPSent();
        },
      );
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }
}
