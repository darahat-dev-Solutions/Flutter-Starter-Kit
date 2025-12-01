import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/payment/domain/payment_state.dart';
import 'package:flutter_starter_kit/features/payment/domain/usecases/create_payment_intent_usecase.dart';
import 'package:flutter_starter_kit/features/payment/domain/usecases/process_payment_usecase.dart';
import 'package:flutter_starter_kit/features/payment/infrastructure/payment_repository.dart';

// Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final logger = ref.watch(appLoggerProvider);

  // Use MockPaymentRepository for testing, StripePaymentRepository for production
  // Change this to StripePaymentRepository when you have a backend
  return MockPaymentRepository(logger);
}); // UseCase Providers
final createPaymentIntentUseCaseProvider =
    Provider<CreatePaymentIntentUseCase>((ref) {
  return CreatePaymentIntentUseCase(ref.watch(paymentRepositoryProvider));
});

final processPaymentUseCaseProvider = Provider<ProcessPaymentUseCase>((ref) {
  return ProcessPaymentUseCase(ref.watch(paymentRepositoryProvider));
});

// Payment Controller Provider
final paymentControllerProvider =
    StateNotifierProvider<PaymentController, PaymentState>((ref) {
  return PaymentController(
    ref.read(createPaymentIntentUseCaseProvider),
    ref.read(processPaymentUseCaseProvider),
    ref.read(appLoggerProvider),
  );
});

/// Payment Controller managing payment state
class PaymentController extends StateNotifier<PaymentState> {
  final CreatePaymentIntentUseCase _createPaymentIntentUseCase;
  final ProcessPaymentUseCase _processPaymentUseCase;
  final AppLogger _logger;

  PaymentController(
    this._createPaymentIntentUseCase,
    this._processPaymentUseCase,
    this._logger,
  ) : super(const PaymentState.initial());

  /// Process a payment with the given amount and currency
  Future<void> makePayment({
    required int amount,
    required String currency,
    String? description,
    String merchantDisplayName = 'Flutter Starter Kit',
  }) async {
    state = const PaymentState.loading();

    try {
      // Step 1: Create payment intent
      final createResult = await _createPaymentIntentUseCase.call(
        CreatePaymentIntentParams(
          amount: amount,
          currency: currency,
          description: description,
        ),
      );

      await createResult.fold(
        (failure) {
          _logger.error('Failed to create payment intent: ${failure.message}');
          state = PaymentState.failure(message: failure.message);
        },
        (paymentIntent) async {
          _logger.info('Payment intent created successfully');

          // Step 2: Process payment with Stripe
          state = const PaymentState.processingPayment();

          final processResult = await _processPaymentUseCase.call(
            ProcessPaymentParams(
              clientSecret: paymentIntent.clientSecret,
              merchantDisplayName: merchantDisplayName,
            ),
          );

          processResult.fold(
            (failure) {
              _logger.error('Payment processing failed: ${failure.message}');
              state = PaymentState.failure(message: failure.message);
            },
            (_) {
              _logger.info('Payment completed successfully');
              state = PaymentState.success(
                paymentIntentId: paymentIntent.id,
                message: 'Payment successful!',
              );
            },
          );
        },
      );
    } catch (e) {
      _logger.error('Unexpected error during payment: $e');
      state = PaymentState.failure(message: 'An unexpected error occurred');
    }
  }

  /// Reset payment state to initial
  void resetState() {
    state = const PaymentState.initial();
  }
}
