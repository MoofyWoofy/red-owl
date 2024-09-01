import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, [int duration = 2]) {
  WidgetsBinding.instance.addPostFrameCallback((timestamp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.none,
        duration: Duration(seconds: duration),
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
