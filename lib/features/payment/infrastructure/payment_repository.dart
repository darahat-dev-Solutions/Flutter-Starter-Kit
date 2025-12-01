import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starter_kit/core/errors/failures.dart';
import 'package:flutter_starter_kit/core/errors/result.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/payment/domain/payment_intent_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// Abstract PaymentRepository defining payment operations
abstract class PaymentRepository {
  /// Creates a payment intent on the backend
  Future<Result<PaymentIntentModel, Failure>> createPaymentIntent({
    required int amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  });

  /// Processes payment using Stripe Payment Sheet
  Future<Result<void, Failure>> processPayment({
    required String clientSecret,
    required String merchantDisplayName,
  });
}

/// Real implementation of PaymentRepository
class StripePaymentRepository implements PaymentRepository {
  final Dio _dio;
  final AppLogger _logger;

  /// Constructor
  StripePaymentRepository(this._dio, this._logger);

  @override
  Future<Result<PaymentIntentModel, Failure>> createPaymentIntent({
    required int amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        return ResultFailure(
          ServerFailure(
            message: 'BASE_API_URL not configured in .env file',
          ),
        );
      }

      final response = await _dio.post(
        '$baseUrl/payment/create-payment-intent',
        data: {
          'amount': amount,
          'currency': currency,
          'description': description,
          'metadata': metadata,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final paymentIntent = PaymentIntentModel.fromJson(response.data);
        _logger.info('Payment intent created: ${paymentIntent.id}');
        return Success(paymentIntent);
      } else {
        return ResultFailure(
          ServerFailure(
            message:
                'Failed to create payment intent: ${response.statusMessage}',
          ),
        );
      }
    } on DioException catch (e) {
      _logger.error('DioException creating payment intent: ${e.message}');
      return ResultFailure(
        NetworkFailure(
          message: e.message ?? 'Network error occurred',
        ),
      );
    } catch (e) {
      _logger.error('Error creating payment intent: $e');
      return ResultFailure(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<void, Failure>> processPayment({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF6366F1),
            ),
          ),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      _logger.info('Payment completed successfully');
      return Success(null);
    } on StripeException catch (e) {
      _logger.error('Stripe error: ${e.error.message}');

      if (e.error.code == FailureCode.Canceled) {
        return ResultFailure(
          PaymentFailure(message: 'Payment cancelled by user'),
        );
      }

      return ResultFailure(
        PaymentFailure(
          message: e.error.localizedMessage ?? 'Payment failed',
        ),
      );
    } catch (e) {
      _logger.error('Error processing payment: $e');
      return ResultFailure(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }
}

/// Mock implementation for testing
class MockPaymentRepository implements PaymentRepository {
  final AppLogger _logger;

  MockPaymentRepository(this._logger);

  @override
  Future<Result<PaymentIntentModel, Failure>> createPaymentIntent({
    required int amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final mockPaymentIntent = PaymentIntentModel(
        id: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: 'pi_mock_secret_${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        currency: currency,
        status: 'requires_payment_method',
        description: description,
        metadata: metadata,
      );

      _logger.info('Mock payment intent created: ${mockPaymentIntent.id}');
      return Success(mockPaymentIntent);
    } catch (e) {
      return ResultFailure(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<void, Failure>> processPayment({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      _logger.info('Mock payment processed successfully');
      return Success(null);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return ResultFailure(
          PaymentFailure(message: 'Payment cancelled'),
        );
      }
      return ResultFailure(
        PaymentFailure(message: e.error.localizedMessage ?? 'Payment failed'),
      );
    } catch (e) {
      return ResultFailure(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }
}
