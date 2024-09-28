import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/user_provider.dart';

class DetailHeader extends ConsumerWidget {
  final String title;
  final String? subtitle;
  const DetailHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final user = ref.watch(userProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 24),
            child: Image.asset('assets/text_logo.png', height: 30),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (context.canPop())
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
              ),
            Expanded(
              child: Image.asset('assets/radar_logo.png', height: 36),
            ),
            Opacity(
              opacity: user.role == UserRole.waiter ? 1 : 0,
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/cart');
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  if (cart.items.isNotEmpty)
                    const Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: SizedBox(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const Divider(
          color: Colors.white,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14),
          ),
      ],
    );
  }
}
