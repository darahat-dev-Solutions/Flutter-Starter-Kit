/// A type-safe result wrapper for handling success and failure cases.
///
/// This sealed class represents the outcome of an operation that can either
/// succeed with a value of type [S] or fail with an error of type [F].
///
/// Use [Success] for successful operations and [Failure] for failed operations.
///
/// Example:
/// ```dart
/// Result<UserModel, Failure> result = await repository.signIn(email, password);
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (user) => print('Success: ${user.email}'),
/// );
/// ```
sealed class Result<S, F> {
  /// Creates a [Result] instance.
  const Result();

  /// Returns `true` if this is a [Success] instance.
  bool get isSuccess => this is Success<S, F>;

  /// Returns `true` if this is a [ResultFailure] instance.
  bool get isFailure => this is ResultFailure<S, F>;

  /// Transforms the result by applying the appropriate function.
  ///
  /// If this is a [ResultFailure], applies [onFailure] to the error.
  /// If this is a [Success], applies [onSuccess] to the value.
  T fold<T>(
    T Function(F failure) onFailure,
    T Function(S success) onSuccess,
  ) {
    return switch (this) {
      Success(value: final value) => onSuccess(value),
      ResultFailure(error: final error) => onFailure(error),
    };
  }

  /// Maps the success value to a new type while preserving failures.
  ///
  /// Example:
  /// ```dart
  /// Result<int, String> result = Success(5);
  /// Result<String, String> mapped = result.map((value) => 'Number: $value');
  /// // mapped is Success('Number: 5')
  /// ```
  Result<T, F> map<T>(T Function(S value) transform) {
    return fold(
      (failure) => ResultFailure(failure),
      (success) => Success(transform(success)),
    );
  }

  /// Maps the failure to a new type while preserving successes.
  ///
  /// Example:
  /// ```dart
  /// Result<int, String> result = ResultFailure('error');
  /// Result<int, CustomError> mapped = result.mapFailure((error) => CustomError(error));
  /// ```
  Result<S, T> mapFailure<T>(T Function(F error) transform) {
    return fold(
      (failure) => ResultFailure(transform(failure)),
      (success) => Success(success),
    );
  }

  /// Chains another result-producing operation if this is a success.
  ///
  /// Useful for sequential operations that all return Results.
  ///
  /// Example:
  /// ```dart
  /// Result<User, Failure> userResult = await getUser();
  /// Result<Profile, Failure> profileResult = userResult.flatMap(
  ///   (user) => getProfile(user.id),
  /// );
  /// ```
  Result<T, F> flatMap<T>(Result<T, F> Function(S value) transform) {
    return fold(
      (failure) => ResultFailure(failure),
      (success) => transform(success),
    );
  }

  /// Returns the success value if present, otherwise returns the default value.
  S getOrElse(S defaultValue) {
    return fold(
      (_) => defaultValue,
      (success) => success,
    );
  }

  /// Returns the success value if present, otherwise computes a default value.
  S getOrElseCompute(S Function() defaultValue) {
    return fold(
      (_) => defaultValue(),
      (success) => success,
    );
  }

  /// Returns the success value if present, otherwise throws an exception.
  S getOrThrow() {
    return fold(
      (failure) => throw Exception('Result is a ResultFailure: $failure'),
      (success) => success,
    );
  }
}

/// Represents a successful result containing a value of type [S].
final class Success<S, F> extends Result<S, F> {
  /// The successful value.
  final S value;

  /// Creates a [Success] with the given [value].
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<S, F> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed result containing an error of type [F].
final class ResultFailure<S, F> extends Result<S, F> {
  /// The error that caused the failure.
  final F error;

  /// Creates a [ResultFailure] with the given [error].
  const ResultFailure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<S, F> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'ResultFailure($error)';
}

/// Extension methods for async Results.
extension AsyncResultExtension<S, F> on Future<Result<S, F>> {
  /// Maps the success value in an async Result.
  Future<Result<T, F>> map<T>(T Function(S value) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// Maps the failure in an async Result.
  Future<Result<S, T>> mapFailure<T>(T Function(F error) transform) async {
    final result = await this;
    return result.mapFailure(transform);
  }

  /// Chains another async operation if successful.
  Future<Result<T, F>> flatMap<T>(
    Future<Result<T, F>> Function(S value) transform,
  ) async {
    final result = await this;
    return result.fold(
      (failure) async => ResultFailure(failure),
      (success) => transform(success),
    );
  }

  /// Folds the async Result.
  Future<T> fold<T>(
    T Function(F failure) onFailure,
    T Function(S success) onSuccess,
  ) async {
    final result = await this;
    return result.fold(onFailure, onSuccess);
  }
}
