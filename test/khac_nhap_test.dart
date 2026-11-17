import 'package:flutter_test/flutter_test.dart';
import 'package:mot_tram_dot_tre/game/puzzle.dart';
import 'package:mot_tram_dot_tre/game/route_check.dart';

void main() {
  test('Màn từ cấp 3 có một đốt tre trong tay và ghép lại được', () {
    for (var level = 3; level <= 30; level++) {
      final puzzle = PuzzleFactory.build(level);
      final gap = puzzle.initialGap;
      final held = puzzle.heldTile;
      expect(gap, isNotNull, reason: 'Màn $level thiếu ô ghép');
      expect(held, isNotNull, reason: 'Màn $level thiếu đốt trong tay');
      expect(puzzle.cells[gap!].piece, Piece.empty);
      expect(held!.locked, isFalse);
      expect(puzzle.attach(gap), isTrue);
      expect(puzzle.cells[gap], same(held));
      expect(puzzle.heldTile, isNull);
      expect(puzzle.detach(gap), isTrue);
      expect(puzzle.heldTile, same(held));
      expect(puzzle.cells[gap].piece, Piece.empty);
    }
  });

  test('Không thể tách ô khóa, cầm hai đốt hoặc ghép vào ô đã có tre', () {
    final puzzle = PuzzleFactory.build(3);
    final gap = puzzle.initialGap!;
    expect(puzzle.detach(puzzle.start), isFalse);
    expect(puzzle.detach(puzzle.finish), isFalse);
    expect(puzzle.detach(gap), isFalse);
    expect(puzzle.attach(puzzle.start), isFalse);
    expect(puzzle.attach(gap), isTrue);
    expect(puzzle.attach(gap), isFalse);
    expect(puzzle.detach(gap), isTrue);
    expect(puzzle.detach(puzzle.start), isFalse);
  });

  test('Chưa thể thắng khi còn đốt tre trong tay', () {
    final held = BambooTile(piece: Piece.straight, mask: 5);
    final puzzle = Puzzle(
      size: 2,
      cells: [
        BambooTile(piece: Piece.end, mask: 2, locked: true),
        BambooTile(piece: Piece.end, mask: 8, locked: true),
        BambooTile(piece: Piece.empty, mask: 0),
        BambooTile(piece: Piece.empty, mask: 0),
      ],
      start: 0,
      finish: 1,
      maxMoves: 10,
      level: 3,
      heldTile: held,
    );
    expect(checkRoute(puzzle).won, isFalse);
    expect(puzzle.attach(2), isTrue);
    expect(checkRoute(puzzle).won, isTrue);
  });

  test('Đốt đầu và cuối không thể bị tách dù ô không khóa', () {
    final puzzle = Puzzle(
      size: 2,
      cells: [
        BambooTile(piece: Piece.end, mask: 2),
        BambooTile(piece: Piece.end, mask: 8),
        BambooTile(piece: Piece.empty, mask: 0),
        BambooTile(piece: Piece.empty, mask: 0),
      ],
      start: 0,
      finish: 1,
      maxMoves: 10,
      level: 3,
    );
    expect(puzzle.detach(0), isFalse);
    expect(puzzle.detach(1), isFalse);
  });

  test('Tách đốt vàng không bỏ qua điều kiện đi qua đốt vàng', () {
    final puzzle = Puzzle(
      size: 2,
      cells: [
        BambooTile(piece: Piece.end, mask: 2, locked: true),
        BambooTile(piece: Piece.end, mask: 8, locked: true),
        BambooTile(piece: Piece.empty, mask: 0),
        BambooTile(piece: Piece.empty, mask: 0),
      ],
      start: 0,
      finish: 1,
      maxMoves: 10,
      level: 5,
      heldTile: BambooTile(piece: Piece.bend, mask: 3, goldTile: true),
    );
    expect(checkRoute(puzzle).won, isFalse);
    expect(puzzle.attach(2), isTrue);
    expect(checkRoute(puzzle).won, isFalse);
  });
}
