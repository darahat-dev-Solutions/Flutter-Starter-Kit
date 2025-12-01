import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_intent_model.freezed.dart';
part 'payment_intent_model.g.dart';

/// Payment Intent Model representing Stripe PaymentIntent
@freezed
class PaymentIntentModel with _$PaymentIntentModel {
  /// PaymentIntentModel factory constructor
  const factory PaymentIntentModel({
    required String id,
    required String clientSecret,
    required int amount,
    required String currency,
    required String status,
    String? description,
    Map<String, dynamic>? metadata,
  }) = _PaymentIntentModel;

  /// Create PaymentIntentModel from JSON
  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);
}
