import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mot_tram_dot_tre/game/puzzle.dart';
import 'package:mot_tram_dot_tre/main.dart';
import 'package:mot_tram_dot_tre/strings.dart';
import 'package:mot_tram_dot_tre/ui/bamboo_board.dart';

void main() {
  test('Mọi màn có kích thước hợp lệ và điểm bắt đầu/kết thúc', () {
    for (var level = 1; level <= 30; level++) {
      final puzzle = PuzzleFactory.build(level);
      expect(puzzle.cells.length, puzzle.size * puzzle.size);
      expect(puzzle.cells[puzzle.start].mask, isNot(0));
      expect(puzzle.cells[puzzle.finish].mask, isNot(0));
      if (level % 5 == 0) expect(puzzle.goldCount, greaterThan(0));
    }
  });
  test('Xoay một vòng quay về hướng ban đầu', () {
    expect(rotateTimes(3, 4), 3);
  });

  testWidgets('Bàn chơi hiển thị trên màn hình hẹp', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BambooGameApp());
    await tester.pumpAndSettle();

    expect(find.byType(Scrollable), findsWidgets);
    for (var i = 0; i < 2; i++) {
      await tester.ensureVisible(find.text(Strings.nextShort));
      await tester.tap(find.text(Strings.nextShort));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Khắc nhập và Khắc xuất cập nhật bàn chơi', (tester) async {
    await tester.pumpWidget(const BambooGameApp());
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text(Strings.nextShort));
      await tester.pumpAndSettle();
    }

    var board = tester.widget<BambooBoard>(find.byType(BambooBoard));
    final gap = board.puzzle.initialGap!;
    expect(board.puzzle.heldTile, isNotNull);
    board.onTap(gap);
    await tester.pump();
    board = tester.widget<BambooBoard>(find.byType(BambooBoard));
    expect(board.puzzle.heldTile, isNull);
    expect(find.text(Strings.detachTitle), findsOneWidget);

    board.onLongPress(gap);
    await tester.pump();
    board = tester.widget<BambooBoard>(find.byType(BambooBoard));
    expect(board.puzzle.heldTile, isNotNull);
    expect(find.text(Strings.attachTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
