import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/user_provider.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_item.dart';
import 'package:nearfield/ui/gradient_button.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    final cart = ref.watch(cartProvider);

    final String paymentSourceName = cart.paymentSource?.name ?? "";

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeader(subtitle: 'Cart', title: paymentSourceName),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  return DetailItem(
                    item: cart.items.keys.elementAt(index),
                    paymentSourceName: paymentSourceName,
                  );
                },
              ),
            ),
            if (cart.isEmpty())
              const Center(
                child: Text('Cart is empty'),
              )
            else
              Column(
                children: [
                  const Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Total: ${cart.total().toStringAsFixed(5)} SOL',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GradientButton(
                    text: 'Start NFC Payment',
                    onPressed: () {
                      context.go('/scan');
                    },
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
