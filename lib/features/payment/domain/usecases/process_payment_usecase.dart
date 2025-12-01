import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/features/payment/infrastructure/payment_repository.dart';

/// Use case for processing payment with Stripe
class ProcessPaymentUseCase {
  final PaymentRepository _repository;

  /// Constructor
  const ProcessPaymentUseCase(this._repository);

  /// Execute the use case
  Future<Result<void, failures.Failure>> call(ProcessPaymentParams params) {
    return _repository.processPayment(
      clientSecret: params.clientSecret,
      merchantDisplayName: params.merchantDisplayName,
    );
  }
}

/// Parameters for processing payment
class ProcessPaymentParams {
  /// Payment Intent client secret
  final String clientSecret;

  /// Merchant display name shown in payment sheet
  final String merchantDisplayName;

  /// Constructor
  const ProcessPaymentParams({
    required this.clientSecret,
    required this.merchantDisplayName,
  });
}
