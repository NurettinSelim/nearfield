import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/provider/database_provider.dart';
import 'package:nearfield/provider/user_provider.dart';
import 'package:nearfield/ui/detail_bottom.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_item.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({
    super.key,
    required this.paymentSourceName,
    required this.categoryName,
  });
  final String paymentSourceName;
  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    final user = ref.read(userProvider);

    final PaymentSource paymentSource = ref.watch(
      databaseProvider.select((value) => value.paymentSources
          .firstWhere((element) => element.name == paymentSourceName)),
    );
    final category = paymentSource.categories
        .firstWhere((element) => element.name == categoryName);

    void addItem() {
      final item = Item(
        name: nameController.text,
        price: double.tryParse(priceController.text) ?? 0,
      );
      ref.read(databaseProvider.notifier).addItem(
            item: item,
            categoryName: categoryName,
            paymentSourceName: paymentSourceName,
          );

      nameController.clear();
      priceController.clear();
    }

    void removeItem(Item item) {
      ref.read(databaseProvider.notifier).removeItem(
            itemName: item.name,
            categoryName: categoryName,
            paymentSourceName: paymentSourceName,
          );
    }

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeader(subtitle: 'Items', title: paymentSourceName),
            Expanded(
              child: ListView.builder(
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final item = category.items[index];
                  return DetailItem(
                    item: item,
                    categoryName: categoryName,
                    paymentSourceName: paymentSourceName,
                  );
                },
              ),
            ),
            if (user.role == UserRole.merchant)
              DetailBottom(
                title: 'Add a New Item',
                nameHintText: 'Item Name...',
                onPressed: addItem,
                nameController: nameController,
                priceController: priceController,
              ),
          ],
        ),
      ),
    );
  }
}
