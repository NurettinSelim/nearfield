import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:nearfield/ui/app_theme.dart';

class BottomTextfield extends StatelessWidget {
  const BottomTextfield({
    super.key,
    required this.textEditingController,
    this.hintText = 'Type here...',
  });
  final TextEditingController textEditingController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: AppTheme.containerColor,
        border: GradientOutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00DBAB),
              Color(0xFF008FC9),
            ],
          ),
          width: 2,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
