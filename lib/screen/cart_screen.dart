import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/user_provider.dart';
import 'package:nearfield/service/mercuryo_service.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_item.dart';
import 'package:nearfield/ui/gradient_button.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

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
                mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Start NFC Payment',
                          onPressed: () {
                            context.go('/scan');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GradientButton(
                          text: 'Pay with Fiat (Mercuryo)',
                          onPressed: () {
                            MercuryoService()
                                .createPaymentSession(
                              'SOL',
                              cart.total().toString(),
                              "USER_WALLET_ADDRESS",
                            )
                                .then((widgetUrl) {
                              // open the widgetUrl in a webview
                              launchUrl(Uri.parse(widgetUrl));
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
