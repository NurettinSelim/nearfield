import 'package:flutter_riverpod/flutter_riverpod.dart';

// UserProvider to manage user's role and payment amount using Riverpod
class UserState {
  final String role;
  final double paymentAmount;

  UserState({required this.role, required this.paymentAmount});

  UserState copyWith({String? role, double? paymentAmount}) {
    return UserState(
      role: role ?? this.role,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(role: '', paymentAmount: 0.0));

  void setRole(String role) {
    state = state.copyWith(role: role);
  }

  void setPaymentAmount(double amount) {
    state = state.copyWith(paymentAmount: amount);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
