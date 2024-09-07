import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.size = 150,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image(
        image: const AssetImage('assets/icon.png'),
        height: size,
        width: size,
      ),
    );
  }
}
