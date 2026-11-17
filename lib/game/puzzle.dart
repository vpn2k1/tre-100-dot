import 'dart:math';

enum Piece { empty, end, straight, bend, tee }

// Direction bit masks: North, East, South, West.
const dirs = [1, 2, 4, 8];
const dr = [-1, 0, 1, 0];
const dc = [0, 1, 0, -1];

int rotateMask(int mask) => ((mask << 1) & 15) | (mask >> 3);

int rotateTimes(int mask, int times) {
  for (var i = 0; i < times % 4; i++) {
    mask = rotateMask(mask);
  }
  return mask;
}

class BambooTile {
  BambooTile({
    required this.piece,
    required this.mask,
    this.locked = false,
    this.once = false,
    this.goldTile = false,
  });
  final Piece piece;
  int mask;
  final bool locked;
  final bool once;
  final bool goldTile;
  int rotations = 0;
  bool get canRotate =>
      !locked && !((once && rotations >= 1)) && piece != Piece.empty;
}

class Puzzle {
  Puzzle({
    required this.size,
    required this.cells,
    required this.start,
    required this.finish,
    required this.maxMoves,
    required this.level,
    this.initialGap,
    this.heldTile,
  });
  final int size, start, finish, maxMoves, level;
  final List<BambooTile> cells;
  final int? initialGap;
  BambooTile? heldTile;
  int get goldCount {
    var count = cells.where((t) => t.goldTile).length;
    if (heldTile?.goldTile == true) count++;
    return count;
  }

  bool detach(int index) {
    if (heldTile != null || index < 0 || index >= cells.length) return false;
    if (index == start || index == finish) return false;
    final tile = cells[index];
    if (tile.piece == Piece.empty || tile.locked) return false;
    heldTile = tile;
    cells[index] = BambooTile(piece: Piece.empty, mask: 0);
    return true;
  }

  bool attach(int index) {
    if (heldTile == null || index < 0 || index >= cells.length) return false;
    if (cells[index].piece != Piece.empty) return false;
    cells[index] = heldTile!;
    heldTile = null;
    return true;
  }
}

int gridSizeFor(int level) {
  if (level <= 5) return 3;
  if (level <= 15) return 4;
  return 5;
}

int _baseMask(Piece piece) => switch (piece) {
      Piece.straight => 1 | 4,
      Piece.bend => 1 | 2,
      Piece.tee => 1 | 2 | 4,
      _ => 0,
    };

Piece _routePiece(bool isEnd, int mask) {
  if (isEnd) return Piece.end;
  if (mask == 5 || mask == 10) return Piece.straight;
  return Piece.bend;
}

// A one-turn tile starts exactly one clockwise rotation away from correct.
int _initialTurns(bool lock, bool once, Random rng) {
  if (lock) return 0;
  if (once) return 3;
  return 1 + rng.nextInt(3);
}

BambooTile _decoyTile(int level, Random rng) {
  final kind = rng.nextInt(5);
  final piece = [
    Piece.empty,
    Piece.empty,
    Piece.straight,
    Piece.bend,
    Piece.tee,
  ][kind];
  final mask = rotateTimes(_baseMask(piece), rng.nextInt(4));
  final locked = level >= 6 && level <= 15 && rng.nextDouble() < .13;
  final once = level >= 16 && rng.nextDouble() < .18;
  return BambooTile(piece: piece, mask: mask, locked: locked, once: once);
}

class PuzzleFactory {
  static Puzzle build(int level) {
    final n = gridSizeFor(level);
    final rng = Random(681 + level * 1109);
    final start = 0, finish = n * n - 1;
    List<int> path = [];
    // Randomized depth-first search creates a guaranteed non-self-intersecting route.
    for (var attempt = 0; attempt < 260; attempt++) {
      final seen = <int>{start};
      final candidate = <int>[start];
      bool walk(int pos) {
        if (pos == finish) return true;
        final r = pos ~/ n, c = pos % n;
        final options = <int>[];
        for (var k = 0; k < 4; k++) {
          final rr = r + dr[k], cc = c + dc[k];
          if (rr >= 0 && rr < n && cc >= 0 && cc < n) options.add(rr * n + cc);
        }
        options.shuffle(rng);
        for (final next in options) {
          if (seen.contains(next)) continue;
          seen.add(next);
          candidate.add(next);
          if (walk(next)) return true;
          candidate.removeLast();
        }
        return false;
      }

      if (walk(start) &&
          candidate.length >= (n * n * .55).ceil() &&
          candidate.length <= (n * n * .92).ceil()) {
        path = List.of(candidate);
        break;
      }
    }
    // Always-solvable fallback (a simple staircase route).
    if (path.isEmpty) {
      path = [0];
      for (var c = 1; c < n; c++) {
        path.add(c);
      }
      for (var r = 1; r < n; r++) {
        path.add(r * n + n - 1);
      }
    }

    final onRoute = path.toSet();
    final correct = List<int>.filled(n * n, 0);
    int direction(int from, int to) {
      final diff = to - from;
      if (diff == -n) return 0;
      if (diff == 1) return 1;
      if (diff == n) return 2;
      return 3;
    }

    for (var i = 0; i < path.length; i++) {
      if (i > 0) {
        correct[path[i]] |= dirs[direction(path[i], path[i - 1])];
      }
      if (i + 1 < path.length) {
        correct[path[i]] |= dirs[direction(path[i], path[i + 1])];
      }
    }
    final special = level % 5 == 0 || level == 30;
    final eligibleGold = path.skip(1).take(max(0, path.length - 2)).toList()
      ..shuffle(rng);
    final goldIndices = <int>{};
    if (special) {
      goldIndices.addAll(eligibleGold.take(min(3, eligibleGold.length)));
    }
    final tiles = <BambooTile>[];
    int? moveIndex;
    if (level >= 3) {
      moveIndex = path[path.length ~/ 2];
    }
    for (var index = 0; index < n * n; index++) {
      if (!onRoute.contains(index)) {
        tiles.add(_decoyTile(level, rng));
        continue;
      }
      final mask = correct[index];
      final isEnd = index == start || index == finish;
      final piece = _routePiece(isEnd, mask);
      var lock = isEnd || (level >= 6 && level <= 15 && rng.nextDouble() < .13);
      if (index == moveIndex) lock = false;
      final once = level >= 16 && !lock && rng.nextDouble() < .35;
      final turns = _initialTurns(lock, once, rng);
      tiles.add(
        BambooTile(
          piece: piece,
          mask: rotateTimes(mask, turns),
          locked: lock,
          once: once,
          goldTile: goldIndices.contains(index),
        ),
      );
    }
    BambooTile? heldTile;
    if (moveIndex != null) {
      heldTile = tiles[moveIndex];
      tiles[moveIndex] = BambooTile(piece: Piece.empty, mask: 0);
    }
    return Puzzle(
      size: n,
      cells: tiles,
      start: start,
      finish: finish,
      maxMoves: n * n * 5,
      level: level,
      initialGap: moveIndex,
      heldTile: heldTile,
    );
  }
}
