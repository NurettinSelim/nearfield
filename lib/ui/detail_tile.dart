import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/provider/user_provider.dart';

class DetailTile extends ConsumerWidget {
  const DetailTile({
    super.key,
    required this.onRemove,
    required this.title,
    required this.onDetail,
  });

  final VoidCallback onRemove;
  final String title;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: user.role == UserRole.merchant,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: onRemove,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF28EFC9)),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00DBAB),
                    Color(0xFF008FC9),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onDetail,
            icon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
