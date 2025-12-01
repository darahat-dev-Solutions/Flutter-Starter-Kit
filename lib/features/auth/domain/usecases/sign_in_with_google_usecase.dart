import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/user_model.dart';
import 'package:flutter_starter_kit/features/auth/infrastructure/auth_repository.dart';

/// Use case for signing in a user with Google OAuth.
///
/// This use case encapsulates the business logic for Google authentication.
/// It takes [NoParams] and returns a [Result] containing either a [UserModel]
/// on success or a [failures.Failure] on error.
class SignInWithGoogleUseCase
    implements UseCase<Result<UserModel, failures.Failure>, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignInWithGoogleUseCase] with the given [_repository].
  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Result<UserModel, failures.Failure>> call(NoParams params) async {
    return await _repository.signInWithGoogle();
  }
}
