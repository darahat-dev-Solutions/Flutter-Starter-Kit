import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/user_model.dart';
import 'package:flutter_starter_kit/features/auth/infrastructure/auth_repository.dart';

/// Use case for signing in a user with email and password.
///
/// This use case encapsulates the business logic for user authentication.
/// It takes [SignInParams] and returns a [Result] containing either a [UserModel]
/// on success or a [failures.Failure] on error.
class SignInUseCase
    implements UseCase<Result<UserModel, failures.Failure>, SignInParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignInUseCase] with the given [_repository].
  SignInUseCase(this._repository);

  @override
  Future<Result<UserModel, failures.Failure>> call(SignInParams params) async {
    return await _repository.signIn(params.email, params.password);
  }
}

/// Parameters for the sign-in use case.
class SignInParams {
  /// User's email address.
  final String email;

  /// User's password.
  final String password;

  /// Creates [SignInParams] with the given [email] and [password].
  const SignInParams({
    required this.email,
    required this.password,
  });
}
