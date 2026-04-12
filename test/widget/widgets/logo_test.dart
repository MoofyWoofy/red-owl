import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/widgets/shared.dart' show Logo;

import '../../helpers/test_helpers.dart';

void main() {
  group('Logo', () {
    testWidgets('renders an Image widget', (tester) async {
      await tester.pumpWidget(makeTestApp(child: const Logo()));
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('uses default size of 150', (tester) async {
      await tester.pumpWidget(makeTestApp(child: const Logo()));
      await tester.pumpAndSettle();
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, 150);
      expect(image.width, 150);
    });

    testWidgets('accepts a custom size', (tester) async {
      await tester.pumpWidget(makeTestApp(child: const Logo(size: 200)));
      await tester.pumpAndSettle();
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, 200);
      expect(image.width, 200);
    });

    testWidgets('wraps image in ClipRRect with rounded corners', (tester) async {
      await tester.pumpWidget(makeTestApp(child: const Logo()));
      await tester.pumpAndSettle();
      expect(find.byType(ClipRRect), findsOneWidget);
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('uses assets/icon.png as image source', (tester) async {
      await tester.pumpWidget(makeTestApp(child: const Logo()));
      await tester.pumpAndSettle();
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName, 'assets/icon.png');
    });
  });
}
