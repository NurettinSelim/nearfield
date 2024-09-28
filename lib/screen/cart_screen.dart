import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/user_provider.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_item.dart';
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
                      'Total: ${cart.total().toStringAsFixed(2)} SOL',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF28EFC9)),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF008fc9),
                              Color(0xFF00dbab),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                          child: Text(
                            'Start NFC Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
