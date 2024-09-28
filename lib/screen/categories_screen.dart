import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/database_provider.dart';
import 'package:nearfield/ui/detail_bottom.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_tile.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';
import 'package:nearfield/provider/user_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  final String paymentSourceName;

  const CategoriesScreen({super.key, required this.paymentSourceName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final PaymentSource paymentSource = ref.watch(
      databaseProvider.select((value) => value.paymentSources
          .firstWhere((element) => element.name == paymentSourceName)),
    );
    final List<Category> categories = paymentSource.categories;

    final TextEditingController controller = TextEditingController();

    void removeCategory(Category category) {
      ref.read(databaseProvider.notifier).removeCategory(
            paymentSourceName: paymentSourceName,
            categoryName: category.name,
          );
    }

    void addCategory() {
      ref.read(databaseProvider.notifier).addCategory(
            category: Category(name: controller.text, items: []),
            paymentSourceName: paymentSourceName,
          );
    }

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeader(title: paymentSourceName, subtitle: 'Categories'),
            Expanded(
              child: categories.isNotEmpty
                  ? ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return DetailTile(
                          onRemove: () => removeCategory(categories[index]),
                          title: categories[index].name,
                          onDetail: () {
                            context.push(
                                '/payment-sources/$paymentSourceName/${categories[index].name}');
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'There are no categories yet. Try adding\nan category first.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
            ),
            if (user.role == UserRole.merchant)
              DetailBottom(
                title: 'Add a New Category',
                nameHintText: 'Category Name...',
                onPressed: addCategory,
                nameController: controller,
              ),
          ],
        ),
      ),
    );
  }
}
