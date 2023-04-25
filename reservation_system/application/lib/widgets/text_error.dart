import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  const TextError({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
