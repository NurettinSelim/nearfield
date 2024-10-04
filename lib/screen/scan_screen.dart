import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/scan_provider.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/gradient_button.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanProvider);

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeader(title: 'NFC Scan'),
            if (scan.state == ScanStateEnum.IDLE)
              const Expanded(child: ScanNFC()),
            if (scan.state == ScanStateEnum.TX_PENDING)
              const Expanded(child: TXPending()),
            if (scan.state == ScanStateEnum.TX_COMPLETE)
              const Expanded(child: TXComplete()),
          ],
        ),
      ),
    );
  }
}

const TextStyle _textStyle = TextStyle(fontSize: 20);
const iconSize = 200.0;

class ScanNFC extends ConsumerWidget {
  const ScanNFC({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Image.asset(
            'assets/loading.png',
            width: double.infinity,
          ),
        ),
        const Spacer(),
        const Text('Scan NFC', style: _textStyle),
        const SizedBox(height: 16),
        GradientButton(
          text: 'Refresh',
          onPressed: () {
            ref.read(scanProvider.notifier).setState(ScanStateEnum.TX_PENDING);
          },
        ),
      ],
    );
  }
}

class TXPending extends StatelessWidget {
  const TXPending({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Image.asset(
            'assets/loading.png',
            width: double.infinity,
          ),
        ),
        const Spacer(),
        const Text('Waiting Tx', style: _textStyle),
        const SizedBox(height: 16),
        const GradientButton(text: 'Refresh')
      ],
    );
  }
}

class TXComplete extends ConsumerWidget {
  const TXComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Image.asset(
            'assets/success.png',
            width: double.infinity,
          ),
        ),
        const Spacer(),
        const Text('Tx Complete', style: _textStyle),
        const SizedBox(height: 16),
        const GradientButton(
          text: 'See Transaction',
          trailing: Icon(Icons.open_in_new),
        ),
        const SizedBox(height: 8),
        GradientButton(
          text: 'Home Page',
          onPressed: () {
            context.go('/payment-sources');
            ref.read(scanProvider.notifier).setState(ScanStateEnum.IDLE);
            ref.read(cartProvider.notifier).clear();
          },
        )
      ],
    );
  }
}
