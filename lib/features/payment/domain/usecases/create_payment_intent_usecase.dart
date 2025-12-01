import 'package:flutter_starter_kit/core/errors/failures.dart' as failures;
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/features/payment/domain/payment_intent_model.dart';
import 'package:flutter_starter_kit/features/payment/infrastructure/payment_repository.dart';

/// Use case for creating a payment intent
class CreatePaymentIntentUseCase {
  final PaymentRepository _repository;

  /// Constructor
  const CreatePaymentIntentUseCase(this._repository);

  /// Execute the use case
  Future<Result<PaymentIntentModel, failures.Failure>> call(
    CreatePaymentIntentParams params,
  ) {
    return _repository.createPaymentIntent(
      amount: params.amount,
      currency: params.currency,
      description: params.description,
      metadata: params.metadata,
    );
  }
}

/// Parameters for creating payment intent
class CreatePaymentIntentParams {
  /// Amount in smallest currency unit (e.g., cents for USD)
  final int amount;

  /// Currency code (e.g., 'usd', 'eur')
  final String currency;

  /// Optional description
  final String? description;

  /// Optional metadata
  final Map<String, dynamic>? metadata;

  /// Constructor
  const CreatePaymentIntentParams({
    required this.amount,
    required this.currency,
    this.description,
    this.metadata,
  });
}
