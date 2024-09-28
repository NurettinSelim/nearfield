import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseState {
  final List<PaymentSource> paymentSources;

  DatabaseState({required this.paymentSources});

  DatabaseState copyWith({List<PaymentSource>? paymentSources}) {
    return DatabaseState(
      paymentSources: paymentSources ?? this.paymentSources,
    );
  }
}

class PaymentSource {
  final List<Category> categories;
  final String name;
  final String walletAddress;

  PaymentSource({
    required this.categories,
    required this.name,
    required this.walletAddress,
  });

  PaymentSource copyWith({
    List<Category>? categories,
    String? name,
    String? walletAddress,
  }) {
    return PaymentSource(
      categories: categories ?? this.categories,
      name: name ?? this.name,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }
}

class Category {
  final List<Item> items;
  final String name;

  Category({required this.items, required this.name});

  Category copyWith({List<Item>? items, String? name}) {
    return Category(
      items: items ?? this.items,
      name: name ?? this.name,
    );
  }
}

class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});

  Item copyWith({String? name, double? price}) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

class DatabaseNotifier extends StateNotifier<DatabaseState> {
  static List<PaymentSource> defaultPaymentSources = [
    PaymentSource(
      name: 'Solana Bar',
      walletAddress: '0x1',
      categories: [
        Category(
          name: 'Specials',
          items: [
            Item(name: 'Margarita', price: 8),
            Item(name: 'Old Fashioned', price: 10),
          ],
        ),
        Category(
          name: 'Coffee',
          items: [
            Item(name: 'Latte', price: 5),
            Item(name: 'Espresso', price: 3),
          ],
        ),
        Category(
          name: 'Alcohol',
          items: [
            Item(name: 'Beer', price: 6),
            Item(name: 'Wine', price: 10),
          ],
        ),
      ],
    ),
    PaymentSource(
      name: 'Vending Machines',
      walletAddress: '0x2',
      categories: [
        Category(
          name: 'Snacks',
          items: [
            Item(name: 'Chips', price: 1),
            Item(name: 'Candy', price: 2),
          ],
        ),
        Category(
          name: 'Drinks',
          items: [
            Item(name: 'Soda', price: 1.5),
            Item(name: 'Water', price: 1),
          ],
        ),
      ],
    ),
  ];

  DatabaseNotifier()
      : super(DatabaseState(paymentSources: defaultPaymentSources));

  void addPaymentSource(PaymentSource paymentSource) {
    state = state.copyWith(
      paymentSources: [...state.paymentSources, paymentSource],
    );
  }

  void removePaymentSource(String paymentSourceName) {
    state = state.copyWith(
      paymentSources: state.paymentSources
          .where((element) => element.name != paymentSourceName)
          .toList(),
    );
  }

  DatabaseState _updatePaymentSource({
    required String paymentSourceName,
    required PaymentSource Function(PaymentSource) update,
  }) {
    final paymentSources = state.paymentSources.map((ps) {
      if (ps.name == paymentSourceName) {
        return update(ps);
      }
      return ps;
    }).toList();
    return state.copyWith(paymentSources: paymentSources);
  }

  PaymentSource _updateCategory({
    required PaymentSource paymentSource,
    required String categoryName,
    required Category Function(Category) update,
  }) {
    final categories = paymentSource.categories.map((cat) {
      if (cat.name == categoryName) {
        return update(cat);
      }
      return cat;
    }).toList();
    return paymentSource.copyWith(categories: categories);
  }

  void addCategory({
    required Category category,
    required String paymentSourceName,
  }) {
    state = _updatePaymentSource(
      paymentSourceName: paymentSourceName,
      update: (paymentSource) {
        return paymentSource.copyWith(
          categories: [...paymentSource.categories, category],
        );
      },
    );
  }

  void removeCategory({
    required String paymentSourceName,
    required String categoryName,
  }) {
    state = _updatePaymentSource(
      paymentSourceName: paymentSourceName,
      update: (paymentSource) {
        final updatedCategories = paymentSource.categories
            .where((cat) => cat.name != categoryName)
            .toList();
        return paymentSource.copyWith(categories: updatedCategories);
      },
    );
  }

  void addItem({
    required Item item,
    required String paymentSourceName,
    required String categoryName,
  }) {
    state = _updatePaymentSource(
      paymentSourceName: paymentSourceName,
      update: (paymentSource) {
        return _updateCategory(
          paymentSource: paymentSource,
          categoryName: categoryName,
          update: (category) {
            return category.copyWith(items: [...category.items, item]);
          },
        );
      },
    );
  }

  void removeItem({
    required String paymentSourceName,
    String? categoryName,
    required String itemName,
  }) {
    state = _updatePaymentSource(
      paymentSourceName: paymentSourceName,
      update: (paymentSource) {
        if (categoryName == null) {
          return _updateCategory(
            paymentSource: paymentSource,
            categoryName: paymentSource.categories
                .firstWhere((element) =>
                    element.items.any((item) => item.name == itemName))
                .name,
            update: (category) {
              final updatedItems = category.items
                  .where((item) => item.name != itemName)
                  .toList();
              return category.copyWith(items: updatedItems);
            },
          );
        }

        return _updateCategory(
          paymentSource: paymentSource,
          categoryName: categoryName,
          update: (category) {
            final updatedItems =
                category.items.where((item) => item.name != itemName).toList();
            return category.copyWith(items: updatedItems);
          },
        );
      },
    );
  }
}

final databaseProvider =
    StateNotifierProvider<DatabaseNotifier, DatabaseState>((ref) {
  return DatabaseNotifier();
});
