import 'package:flutter/material.dart';
import 'package:nearfield/ui/bottom_textfield.dart';

class DetailBottom extends StatefulWidget {
  const DetailBottom({
    super.key,
    required this.onPressed,
    required this.nameController,
    this.nameHintText = 'Name',
    this.walletController,
    this.walletHintText = 'Wallet Address...',
    this.priceController,
    this.priceHintText = 'Price...',
    required this.title,
  });

  final VoidCallback onPressed;
  final TextEditingController nameController;
  final String nameHintText;
  final TextEditingController? walletController;
  final String walletHintText;
  final TextEditingController? priceController;
  final String priceHintText;
  final String title;

  @override
  State<DetailBottom> createState() => _DetailBottomState();
}

class _DetailBottomState extends State<DetailBottom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white),
        const SizedBox(height: 10),
        Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BottomTextfield(
                    textEditingController: widget.nameController,
                    hintText: widget.nameHintText,
                  ),
                  if (widget.walletController != null)
                    const SizedBox(height: 10),
                  if (widget.walletController != null)
                    BottomTextfield(
                      textEditingController: widget.walletController!,
                      hintText: widget.walletHintText,
                    ),
                ],
              ),
            ),
            if (widget.priceController != null) const SizedBox(width: 10),
            if (widget.priceController != null)
              Expanded(
                child: BottomTextfield(
                  textEditingController: widget.priceController!,
                  hintText: widget.priceHintText,
                ),
              ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: widget.onPressed,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF5AC9E8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
