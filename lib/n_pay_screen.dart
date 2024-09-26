// Screen 3: Easily Payment Method Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/neon_button.dart';
import 'package:nearfield/user_provider.dart';

class NPayScreen extends ConsumerStatefulWidget {
  const NPayScreen({super.key});

  @override
  _NPayScreenState createState() => _NPayScreenState();
}

class _NPayScreenState extends ConsumerState<NPayScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(userProvider.notifier);
    final paymentAmount = ref.watch(userProvider).paymentAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/text_logo.png'),
              const Text(
                "N-PAY",
                style: TextStyle(color: Color(0xFFCCFD02), fontSize: 24),
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  NeonButton(
                    text: 'Amount: \$${paymentAmount.toStringAsFixed(2)}',
                    onPressed: () {
                      _showAmountDialog(userNotifier);
                    },
                  ),
                  const SizedBox(height: 20),
                  NeonButton(
                    text: 'Send Transfer Request',
                    onPressed: () {
                      // Handle Send Transfer Request button press
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Transfer request of \$${paymentAmount.toStringAsFixed(2)} sent!'),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAmountDialog(UserNotifier userNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Amount"),
          content: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            decoration: const InputDecoration(hintText: "Enter amount"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                _amountController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Set"),
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                userNotifier.setPaymentAmount(amount);
                _amountController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
