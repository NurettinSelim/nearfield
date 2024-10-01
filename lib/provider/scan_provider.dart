import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanState {
  ScanStateEnum state;
  String message;
  ScanState({required this.state, required this.message});

  ScanState copyWith({ScanStateEnum? state, String? message}) {
    return ScanState(
        state: state ?? this.state, message: message ?? this.message);
  }
}

enum ScanStateEnum { IDLE, TX_PENDING, TX_COMPLETE, ERROR }

class ScanNotifier extends StateNotifier<ScanState> {
  ScanNotifier() : super(ScanState(state: ScanStateEnum.IDLE, message: ''));

  void setState(ScanStateEnum newState) {
    state = state.copyWith(state: newState);

    if (newState == ScanStateEnum.TX_PENDING) {
      // Simulate a transaction
      Future.delayed(const Duration(seconds: 2), () {
        setState(ScanStateEnum.TX_COMPLETE);
      });
    }
  }

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }
}

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  return ScanNotifier();
});
