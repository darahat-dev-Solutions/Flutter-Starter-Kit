import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/infrastructure/auth_repository.dart';

/// Use case for signing out the current user.
///
/// This use case encapsulates the business logic for user sign out.
/// It takes [NoParams] and returns a [Result] indicating success or failure.
class SignOutUseCase
    implements UseCase<Result<void, failures.Failure>, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignOutUseCase] with the given [_repository].
  SignOutUseCase(this._repository);

  @override
  Future<Result<void, failures.Failure>> call(NoParams params) async {
    return await _repository.signOut();
  }
}
