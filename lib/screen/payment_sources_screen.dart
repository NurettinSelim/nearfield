import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/provider/database_provider.dart';
import 'package:nearfield/ui/detail_bottom.dart';
import 'package:nearfield/ui/detail_header.dart';
import 'package:nearfield/ui/detail_tile.dart';
import 'package:nearfield/ui/gradient_scaffold.dart';
import 'package:nearfield/provider/user_provider.dart';

class PaymentSourcesScreen extends ConsumerStatefulWidget {
  const PaymentSourcesScreen({super.key});

  @override
  _PaymentSourcesScreenState createState() => _PaymentSourcesScreenState();
}

class _PaymentSourcesScreenState extends ConsumerState<PaymentSourcesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _walletAddressController =
      TextEditingController();

  void _removePaymentSource(PaymentSource paymentSource) {
    final database = ref.read(databaseProvider.notifier);
    database.removePaymentSource(paymentSource.name);
  }

  void _addPaymentSource() {
    final database = ref.read(databaseProvider.notifier);
    database.addPaymentSource(PaymentSource(
      name: _nameController.text,
      walletAddress: _walletAddressController.text,
      categories: [],
    ));
    _nameController.clear();
    _walletAddressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final paymentSources = database.paymentSources;

    final user = ref.read(userProvider);

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeader(title: 'Payment Sources'),
            Expanded(
              child: ListView.builder(
                itemCount: paymentSources.length,
                itemBuilder: (context, index) {
                  return DetailTile(
                    onRemove: () => _removePaymentSource(paymentSources[index]),
                    title: paymentSources[index].name,
                    onDetail: () {
                      context.push(
                          '/payment-sources/${paymentSources[index].name}');
                    },
                  );
                },
              ),
            ),
            if (user.role == UserRole.merchant)
              DetailBottom(
                title: 'Add a Payment Source',
                nameHintText: 'Payment Source Name...',
                onPressed: _addPaymentSource,
                nameController: _nameController,
                walletController: _walletAddressController,
              ),
          ],
        ),
      ),
    );
  }
}
