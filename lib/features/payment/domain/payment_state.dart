import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

/// Payment State representing different payment states
@freezed
class PaymentState with _$PaymentState {
  /// Initial state
  const factory PaymentState.initial() = PaymentInitial;

  /// Loading state
  const factory PaymentState.loading() = PaymentLoading;

  /// Success state
  const factory PaymentState.success({
    required String paymentIntentId,
    String? message,
  }) = PaymentSuccess;

  /// Failure state
  const factory PaymentState.failure({
    required String message,
    String? code,
  }) = PaymentFailure;

  /// Processing payment sheet
  const factory PaymentState.processingPayment() = PaymentProcessing;
}
