// merchant_main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/neon_button.dart';

class MerchantMainScreen extends StatelessWidget {
  const MerchantMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Merchant')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset('assets/text_logo.png'),
          const SizedBox(height: 20),
          // N-PAY Button
          NeonButton(
            onPressed: () {
              context.push('/merchant/n-pay');
            },
            text: "N-PAY",
          ),
          const SizedBox(height: 20),
          // 'Coming Soon' Buttons
          ...List.generate(4, (index) {
            return const Column(
              children: [
                NeonButton(
                  enabled: false,
                  onPressed: null,
                  text: "Coming Soon",
                ),
                SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }
}
