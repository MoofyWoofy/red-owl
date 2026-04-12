import 'package:flutter/material.dart';

/// Displays the Red Owl app icon as a rounded-square image.
///
/// Used on the home screen as the main branding element and inside the
/// "About" dialog ([showAboutDialog]) as the application icon.
class Logo extends StatelessWidget {
  const Logo({
    super.key,
    /// Side length of the logo in logical pixels. Defaults to 150.
    this.size = 150,
  });

  /// Side length of the square logo image in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Match the rounded-square style of modern app icons.
      borderRadius: BorderRadius.circular(16),
      child: Image(
        image: const AssetImage('assets/icon.png'),
        height: size,
        width: size,
      ),
    );
  }
}
