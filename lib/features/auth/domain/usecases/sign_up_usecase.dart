import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/user_model.dart';
import 'package:flutter_starter_kit/features/auth/infrastructure/auth_repository.dart';

/// Use case for signing up a new user with email, password, and name.
///
/// This use case encapsulates the business logic for user registration.
/// It takes [SignUpParams] and returns a [Result] containing either a [UserModel]
/// on success or a [failures.Failure] on error.
class SignUpUseCase
    implements UseCase<Result<UserModel, failures.Failure>, SignUpParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignUpUseCase] with the given [_repository].
  SignUpUseCase(this._repository);

  @override
  Future<Result<UserModel, failures.Failure>> call(SignUpParams params) async {
    return await _repository.signUp(
      params.email,
      params.password,
      params.name,
    );
  }
}

/// Parameters for the sign-up use case.
class SignUpParams {
  /// User's email address.
  final String email;

  /// User's password.
  final String password;

  /// User's display name.
  final String name;

  /// Creates [SignUpParams] with the given [email], [password], and [name].
  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
