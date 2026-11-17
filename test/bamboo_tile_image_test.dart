import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mot_tram_dot_tre/ui/bamboo_tile_image.dart';

void main() {
  testWidgets('Ảnh tre đúng loại và hướng cho mọi bitmask', (tester) async {
    const pieces = <int, (String, int)>{
      1: ('tre_dau.png', 0),
      2: ('tre_dau.png', 1),
      4: ('tre_dau.png', 2),
      8: ('tre_dau.png', 3),
      5: ('tre_thang.png', 0),
      10: ('tre_thang.png', 1),
      3: ('tre_cong.png', 0),
      6: ('tre_cong.png', 1),
      12: ('tre_cong.png', 2),
      9: ('tre_cong.png', 3),
      7: ('tre_nga_ba.png', 0),
      14: ('tre_nga_ba.png', 1),
      13: ('tre_nga_ba.png', 2),
      11: ('tre_nga_ba.png', 3),
    };

    for (final entry in pieces.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox.square(
            dimension: 80,
            child: BambooTileImage(entry.key),
          ),
        ),
      );
      final image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName,
          'assets/bamboo/${entry.value.$1}');
      expect(tester.widget<RotatedBox>(find.byType(RotatedBox)).quarterTurns,
          entry.value.$2);
      expect(tester.takeException(), isNull);
    }
  });
}
