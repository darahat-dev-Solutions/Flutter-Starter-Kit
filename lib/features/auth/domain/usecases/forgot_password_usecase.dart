import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/infrastructure/auth_repository.dart';

/// Use case for sending a password reset email to a user.
///
/// This use case encapsulates the business logic for password reset.
/// It takes [ForgotPasswordParams] and returns a [Result] indicating success or failure.
class ForgotPasswordUseCase
    implements UseCase<Result<void, failures.Failure>, ForgotPasswordParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [ForgotPasswordUseCase] with the given [_repository].
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Result<void, failures.Failure>> call(
      ForgotPasswordParams params) async {
    return await _repository.sendPasswordResetEmail(params.email);
  }
}

/// Parameters for the forgot password use case.
class ForgotPasswordParams {
  /// User's email address.
  final String email;

  /// Creates [ForgotPasswordParams] with the given [email].
  const ForgotPasswordParams({required this.email});
}
