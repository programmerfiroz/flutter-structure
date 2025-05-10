import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  const CustomLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.black54 : Colors.white60,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
