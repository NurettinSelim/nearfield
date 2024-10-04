import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearfield/provider/cart_provider.dart';
import 'package:nearfield/provider/database_provider.dart';
import 'package:nearfield/provider/user_provider.dart';

class DetailItem extends ConsumerStatefulWidget {
  const DetailItem({
    super.key,
    required this.item,
    this.categoryName,
    required this.paymentSourceName,
  });

  final Item item;
  final String? categoryName;
  final String paymentSourceName;

  @override
  ConsumerState<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends ConsumerState<DetailItem> {
  void removeItem() {
    ref.read(databaseProvider.notifier).removeItem(
          itemName: widget.item.name,
          categoryName: widget.categoryName,
          paymentSourceName: widget.paymentSourceName,
        );
  }

  void addItemToCart() {
    final PaymentSource paymentSource = ref.watch(
      databaseProvider.select((value) => value.paymentSources
          .firstWhere((element) => element.name == widget.paymentSourceName)),
    );
    ref.read(cartProvider.notifier).addItem(paymentSource, widget.item);
  }

  void removeItemFromCart() {
    ref.read(cartProvider.notifier).removeItem(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final cartItems = ref.watch(cartProvider);
    final itemEntry = cartItems.items.entries.firstWhere(
        (element) => element.key.name == widget.item.name,
        orElse: () => MapEntry(widget.item, 0));

    final itemValue = itemEntry.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: user.role == UserRole.merchant,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: removeItem,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4E5D72),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ImagePlaceholder(
                        text: 'Image',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.item.name,
                              style: const TextStyle(
                                color: Color(0xFF2CFFD6),
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.item.price.toStringAsFixed(5),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Text(
                                  "  SOL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (user.role == UserRole.waiter)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: addItemToCart,
                                    icon: const Icon(Icons.add),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    itemValue.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: removeItemFromCart,
                                    icon: const Icon(Icons.remove),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final String text;

  const ImagePlaceholder({
    super.key,
    this.width = 200,
    this.height = 200,
    this.text = 'Image',
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PlaceholderPainter(placeholderText: text),
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  final String placeholderText;

  _PlaceholderPainter({required this.placeholderText});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw corner brackets
    Paint bracketPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    double bracketSize = 20;

    // Top-left bracket
    canvas.drawLine(const Offset(0, 0), Offset(bracketSize, 0),
        bracketPaint); // Horizontal line
    canvas.drawLine(const Offset(0, 0), Offset(0, bracketSize),
        bracketPaint); // Vertical line

    // Top-right bracket
    canvas.drawLine(Offset(size.width - bracketSize, 0), Offset(size.width, 0),
        bracketPaint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, bracketSize), bracketPaint);

    // Bottom-left bracket
    canvas.drawLine(Offset(0, size.height - bracketSize),
        Offset(0, size.height), bracketPaint);
    canvas.drawLine(
        Offset(0, size.height), Offset(bracketSize, size.height), bracketPaint);

    // Bottom-right bracket
    canvas.drawLine(Offset(size.width - bracketSize, size.height),
        Offset(size.width, size.height), bracketPaint);
    canvas.drawLine(Offset(size.width, size.height - bracketSize),
        Offset(size.width, size.height), bracketPaint);

    // Draw "Image" text in center
    TextSpan textSpan = TextSpan(
      text: placeholderText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    Offset textPosition = Offset(
      (size.width - textPainter.width) * 0.5,
      (size.height - textPainter.height) * 0.5,
    );

    textPainter.paint(canvas, textPosition);
  }

  @override
  bool shouldRepaint(_PlaceholderPainter oldDelegate) => false;
}
