import 'package:flutter/material.dart';

/// Displays a floating, card-style snack bar centered vertically on screen.
///
/// Unlike the default [SnackBar], this variant:
/// - Has no background or elevation, so the [Card] acts as the visible surface.
/// - Is pinned to the vertical center of the screen (not the bottom) to avoid
///   being obscured by the on-screen keyboard.
/// - Is non-dismissible by swipe ([DismissDirection.none]).
///
/// The callback is deferred to the next frame via [addPostFrameCallback] so
/// that it is safe to call during a widget's `build` phase without triggering
/// nested rebuild warnings.
///
/// [context] – the [BuildContext] used to look up the [ScaffoldMessenger].
/// [text]    – the message to display.
/// [duration]– how many seconds the snack bar stays visible (default 2).
void showSnackBar(BuildContext context, String text, [int duration = 2]) {
  WidgetsBinding.instance.addPostFrameCallback((timestamp) {
    // The callback runs a frame later; the widget may be gone by then.
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Transparent background so only the Card is visible.
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        // Prevent the user from swiping it away.
        dismissDirection: DismissDirection.none,
        duration: Duration(seconds: duration),
        // Position the card at the vertical midpoint of the screen.
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(text),
              ),
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  });
}
