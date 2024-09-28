import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/provider/database_provider.dart';

class CartState {
  final Map<Item, int> items;
  final PaymentSource? paymentSource;
  CartState(this.items, this.paymentSource);

  CartState copyWith({Map<Item, int>? items, PaymentSource? paymentSource}) {
    return CartState(
      items ?? this.items,
      paymentSource ?? this.paymentSource,
    );
  }

  bool isEmpty() {
    return items.isEmpty;
  }

  int countOf(Item item) {
    return items[item] ?? 0;
  }

  double total() {
    return items.entries.fold(0, (total, entry) {
      return total + entry.key.price * entry.value;
    });
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState({}, null));

  void addItem(PaymentSource paymentSource, Item item) {
    final items = state.items;
    if (items.containsKey(item)) {
      items[item] = items[item]! + 1;
    } else {
      items[item] = 1;
    }
    state = state.copyWith(items: items, paymentSource: paymentSource);
  }

  void removeItem(Item item) {
    final items = state.items;
    if (items.containsKey(item)) {
      if (items[item]! > 1) {
        items[item] = items[item]! - 1;
      } else {
        items.remove(item);
      }
    }
    if (items.isEmpty) {
      state = state.copyWith(items: items, paymentSource: null);
    } else {
      state = state.copyWith(items: items);
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
