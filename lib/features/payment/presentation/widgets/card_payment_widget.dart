import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/payment/application/payment_provider.dart';
import 'package:flutter_starter_kit/features/payment/domain/payment_state.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CardPaymentWidget extends ConsumerStatefulWidget {
  const CardPaymentWidget({super.key});

  @override
  ConsumerState<CardPaymentWidget> createState() => _CardPaymentWidgetState();
}

class _CardPaymentWidgetState extends ConsumerState<CardPaymentWidget> {
  final controller = CardEditController();
  int _amount = 1000; // Default amount in cents ($10.00)
  String _currency = 'USD';

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    ref.listen<PaymentState>(paymentControllerProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        processingPayment: () {
          // Show processing message if needed
        },
        success: (paymentIntentId, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message ?? 'Payment Successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        },
        failure: (message, code) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    final paymentState = ref.watch(paymentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.creditCard),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount input
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (in cents)',
                helperText: 'e.g., 1000 = \$10.00',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = int.tryParse(value) ?? 1000;
                });
              },
              controller: TextEditingController(text: _amount.toString()),
            ),
            const SizedBox(height: 16),

            // Currency dropdown
            DropdownButtonFormField<String>(
              value: _currency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                DropdownMenuItem(value: 'GBP', child: Text('GBP')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currency = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Card field
            CardField(
              controller: controller,
            ),
            const SizedBox(height: 20),

            // Pay button
            ElevatedButton(
              onPressed: controller.complete && !_isProcessing
                  ? _handlePayPress
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: paymentState.when(
                initial: () => Text(
                  '${localizations.pay} \$${(_amount / 100).toStringAsFixed(2)}',
                ),
                loading: () => const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                processingPayment: () => const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                success: (_, __) => const Icon(Icons.check),
                failure: (_, __) => Text(
                  '${localizations.pay} \$${(_amount / 100).toStringAsFixed(2)}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test card info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Card',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Card: 4242 4242 4242 4242'),
                  const Text('Expiry: Any future date'),
                  const Text('CVC: Any 3 digits'),
                  const Text('ZIP: Any 5 digits'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isProcessing {
    final state = ref.read(paymentControllerProvider);
    return state.maybeWhen(
      loading: () => true,
      processingPayment: () => true,
      orElse: () => false,
    );
  }

  Future<void> _handlePayPress() async {
    await ref.read(paymentControllerProvider.notifier).makePayment(
          amount: _amount,
          currency: _currency.toLowerCase(),
          description: 'Payment via Flutter Starter Kit',
        );
  }
}
