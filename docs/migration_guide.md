# Migration Guide: Applying Result Pattern & UseCase Layer

This guide shows how to apply the Result pattern and UseCase layer to other modules in the Flutter Starter Kit, using the Auth module as a reference.

## Quick Reference

### Step 1: Update Repository Methods

**Before:**

```dart
class SettingsRepository {
  Future<ThemeMode> getThemeMode() async {
    try {
      final theme = await _box.get('theme');
      return theme ?? ThemeMode.system;
    } catch (e) {
      throw Exception('Failed to get theme: $e');
    }
  }
}
```

**After:**

```dart
import 'package:flutter_starter_kit/core/errors/failures.dart';
import 'package:flutter_starter_kit/core/errors/result.dart';

class SettingsRepository {
  Future<Result<ThemeMode, Failure>> getThemeMode() async {
    try {
      final theme = await _box.get('theme');
      return Success(theme ?? ThemeMode.system);
    } catch (e) {
      return ResultFailure(CacheFailure(message: 'Failed to get theme: $e'));
    }
  }
}
```

### Step 2: Create UseCases

**File Structure:**

```
lib/features/settings/domain/usecases/
├── get_theme_mode_usecase.dart
├── save_theme_mode_usecase.dart
├── get_locale_usecase.dart
└── save_locale_usecase.dart
```

**Template:**

```dart
import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/usecases/usecase.dart';

class GetThemeModeUseCase implements UseCase<ThemeMode, NoParams> {
  final SettingsRepository _repository;

  const GetThemeModeUseCase(this._repository);

  @override
  Future<Result<ThemeMode, failures.Failure>> call(NoParams params) {
    return _repository.getThemeMode();
  }
}
```

**With Parameters:**

```dart
class SaveThemeModeUseCase implements UseCase<void, SaveThemeModeParams> {
  final SettingsRepository _repository;

  const SaveThemeModeUseCase(this._repository);

  @override
  Future<Result<void, failures.Failure>> call(SaveThemeModeParams params) {
    return _repository.saveThemeMode(params.themeMode);
  }
}

class SaveThemeModeParams {
  final ThemeMode themeMode;

  const SaveThemeModeParams({required this.themeMode});
}
```

### Step 3: Update Controller

**Before:**

```dart
class SettingsController extends StateNotifier<SettingsState> {
  final SettingsRepository _repository;

  Future<void> loadTheme() async {
    try {
      final theme = await _repository.getThemeMode();
      state = SettingsLoaded(theme);
    } catch (e) {
      state = SettingsError(e.toString());
    }
  }
}
```

**After:**

```dart
class SettingsController extends StateNotifier<SettingsState> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;

  Future<void> loadTheme() async {
    final result = await _getThemeModeUseCase.call(const NoParams());

    result.fold(
      (failure) => state = SettingsError(failure.message),
      (theme) => state = SettingsLoaded(theme),
    );
  }

  Future<void> saveTheme(ThemeMode theme) async {
    final result = await _saveThemeModeUseCase.call(
      SaveThemeModeParams(themeMode: theme),
    );

    result.fold(
      (failure) => state = SettingsError(failure.message),
      (_) => state = SettingsSaved(),
    );
  }
}
```

### Step 4: Add Providers

```dart
// UseCase Providers
final getThemeModeUseCaseProvider = Provider<GetThemeModeUseCase>((ref) {
  return GetThemeModeUseCase(ref.watch(settingsRepositoryProvider));
});

final saveThemeModeUseCaseProvider = Provider<SaveThemeModeUseCase>((ref) {
  return SaveThemeModeUseCase(ref.watch(settingsRepositoryProvider));
});

// Controller Provider
final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(
    ref.read(getThemeModeUseCaseProvider),
    ref.read(saveThemeModeUseCaseProvider),
  );
});
```

## Common Patterns

### Pattern 1: Simple Success/Failure

```dart
Future<Result<void, Failure>> deleteItem(String id) async {
  try {
    await _api.delete(id);
    return Success(null); // void success
  } catch (e) {
    return ResultFailure(ServerFailure(message: e.toString()));
  }
}
```

### Pattern 2: Conditional Success

```dart
Future<Result<User, Failure>> findUser(String id) async {
  try {
    final user = await _db.findById(id);

    if (user == null) {
      return ResultFailure(NotFoundFailure(message: 'User not found'));
    }

    return Success(user);
  } catch (e) {
    return ResultFailure(DatabaseFailure(message: e.toString()));
  }
}
```

### Pattern 3: Multiple Error Types

```dart
Future<Result<Data, Failure>> fetchData() async {
  try {
    if (!await _connectivity.isConnected()) {
      return ResultFailure(NetworkFailure(message: 'No internet connection'));
    }

    final response = await _api.getData();

    if (response.statusCode == 401) {
      return ResultFailure(AuthFailure(message: 'Unauthorized'));
    }

    if (response.statusCode != 200) {
      return ResultFailure(ServerFailure(message: 'Server error'));
    }

    return Success(Data.fromJson(response.data));
  } catch (e) {
    return ResultFailure(UnexpectedFailure(message: e.toString()));
  }
}
```

### Pattern 4: Chaining Operations

```dart
Future<Result<ProcessedData, Failure>> processAndSave(String id) async {
  final fetchResult = await _fetchUseCase.call(FetchParams(id: id));

  return fetchResult.flatMap((data) async {
    final processed = process(data);
    return _saveUseCase.call(SaveParams(data: processed));
  });
}
```

### Pattern 5: Transforming Results

```dart
Future<Result<String, Failure>> getUserName(String id) async {
  final result = await _getUserUseCase.call(GetUserParams(id: id));

  return result.map((user) => user.name); // Transform User → String
}
```

## Testing with Result Pattern

### Unit Test Template

```dart
void main() {
  late MockSettingsRepository mockRepository;
  late GetThemeModeUseCase useCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetThemeModeUseCase(mockRepository);
  });

  group('GetThemeModeUseCase', () {
    test('should return Success with ThemeMode when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getThemeMode())
          .thenAnswer((_) async => Success(ThemeMode.dark));

      // Act
      final result = await useCase.call(const NoParams());

      // Assert
      expect(result, isA<Success<ThemeMode, Failure>>());
      result.fold(
        (failure) => fail('Expected Success but got Failure'),
        (theme) => expect(theme, ThemeMode.dark),
      );
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getThemeMode())
          .thenAnswer((_) async => ResultFailure(CacheFailure(message: 'Error')));

      // Act
      final result = await useCase.call(const NoParams());

      // Assert
      expect(result, isA<ResultFailure<ThemeMode, Failure>>());
      result.fold(
        (failure) => expect(failure.message, 'Error'),
        (theme) => fail('Expected Failure but got Success'),
      );
    });
  });
}
```

### Controller Test Template

```dart
void main() {
  late MockGetThemeModeUseCase mockGetThemeUseCase;
  late SettingsController controller;

  setUp(() {
    mockGetThemeUseCase = MockGetThemeModeUseCase();
    controller = SettingsController(mockGetThemeUseCase);
  });

  group('loadTheme', () {
    test('should set Loaded state when use case succeeds', () async {
      // Arrange
      when(() => mockGetThemeUseCase.call(any()))
          .thenAnswer((_) async => Success(ThemeMode.dark));

      // Act
      await controller.loadTheme();

      // Assert
      expect(controller.state, isA<SettingsLoaded>());
      final state = controller.state as SettingsLoaded;
      expect(state.themeMode, ThemeMode.dark);
    });

    test('should set Error state when use case fails', () async {
      // Arrange
      when(() => mockGetThemeUseCase.call(any()))
          .thenAnswer((_) async => ResultFailure(CacheFailure(message: 'Cache error')));

      // Act
      await controller.loadTheme();

      // Assert
      expect(controller.state, isA<SettingsError>());
      final state = controller.state as SettingsError;
      expect(state.message, 'Cache error');
    });
  });
}
```

## Checklist for Each Module

- [ ] Update Repository methods to return `Result<T, Failure>`
- [ ] Create UseCase classes for each operation
- [ ] Create Params classes where needed
- [ ] Update Controller to use UseCases
- [ ] Replace try-catch with result.fold()
- [ ] Add UseCase providers
- [ ] Update Controller provider to inject UseCases
- [ ] Remove unused imports (especially exception-related)
- [ ] Write unit tests for UseCases
- [ ] Write unit tests for Controller
- [ ] Test all UI flows manually

## Common Pitfalls

### ❌ Don't: Use throw in Repository

```dart
Future<Result<User, Failure>> getUser() async {
  throw Exception('Error'); // WRONG!
}
```

### ✅ Do: Return ResultFailure

```dart
Future<Result<User, Failure>> getUser() async {
  return ResultFailure(ServerFailure(message: 'Error')); // CORRECT!
}
```

### ❌ Don't: Ignore fold return value

```dart
await useCase.call(params); // WRONG! Result not handled
state = Success(); // Assuming success
```

### ✅ Do: Handle both cases with fold

```dart
final result = await useCase.call(params);
result.fold(
  (failure) => state = Error(failure.message),
  (data) => state = Loaded(data),
);
```

### ❌ Don't: Use if-else with Result types

```dart
final result = await useCase.call(params);
if (result is Success) { // AVOID! Use fold instead
  // ...
}
```

### ✅ Do: Use fold for pattern matching

```dart
result.fold(
  (failure) => handleFailure(failure),
  (data) => handleSuccess(data),
);
```

## Module Priority

Recommended order for migration:

1. ✅ **Auth** (Complete)
2. **Settings** (Simple, good next step)
3. **Tasks** (Medium complexity)
4. **Notifications** (Similar to Auth)
5. **Payment** (Complex, do last)

## Additional Resources

- Auth module implementation: `lib/features/auth/`
- Result class: `lib/core/errors/result.dart`
- UseCase base: `lib/core/usecases/usecase.dart`
- Failures: `lib/core/errors/failures.dart`
- Implementation summary: `docs/clean_architecture_implementation.md`

---

**Remember**: The goal is predictable, type-safe error handling with clear separation of concerns. Every operation should return a Result, and every controller should use UseCases.
