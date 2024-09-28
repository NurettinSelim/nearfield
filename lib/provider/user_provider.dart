import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { merchant, waiter }

class UserState {
  final UserRole role;
  final double paymentAmount;

  UserState({required this.role, required this.paymentAmount});

  UserState copyWith({UserRole? role, double? paymentAmount}) {
    return UserState(
      role: role ?? this.role,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(role: UserRole.waiter, paymentAmount: 0.0));

  void setRole(UserRole role) {
    state = state.copyWith(role: role);
  }

  void setPaymentAmount(double amount) {
    state = state.copyWith(paymentAmount: amount);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
