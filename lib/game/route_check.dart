import 'dart:collection';

import 'puzzle.dart';

class RouteResult {
  const RouteResult(this.won, this.connected);
  final bool won;
  final Set<int> connected;
}

// BFS trên trạng thái (ô, tập đốt vàng đã qua). Xem docs/ARCHITECTURE.md.
RouteResult checkRoute(Puzzle puzzle) {
  final n = puzzle.size;
  final goldPositions = <int>[];
  for (var i = 0; i < puzzle.cells.length; i++) {
    if (puzzle.cells[i].goldTile) goldPositions.add(i);
  }
  final allGold = (1 << goldPositions.length) - 1;
  final goldBit = <int, int>{};
  for (var i = 0; i < goldPositions.length; i++) {
    goldBit[goldPositions[i]] = 1 << i;
  }
  final queue = Queue<(int, int)>();
  queue.add((puzzle.start, goldBit[puzzle.start] ?? 0));
  final seen = <(int, int)>{};
  final connected = <int>{};
  bool won = false;
  while (queue.isNotEmpty) {
    final (pos, collected) = queue.removeFirst();
    if (!seen.add((pos, collected))) continue;
    connected.add(pos);
    if (pos == puzzle.finish &&
        collected == allGold &&
        puzzle.heldTile == null) {
      won = true;
      break;
    }
    final r = pos ~/ n, c = pos % n;
    final ownMask = puzzle.cells[pos].mask;
    for (var k = 0; k < 4; k++) {
      if ((ownMask & dirs[k]) == 0) continue;
      final nr = r + dr[k], nc = c + dc[k];
      if (nr < 0 || nr >= n || nc < 0 || nc >= n) continue;
      final next = nr * n + nc;
      if ((puzzle.cells[next].mask & dirs[(k + 2) % 4]) == 0) continue;
      queue.add((next, collected | (goldBit[next] ?? 0)));
    }
  }
  return RouteResult(won, connected);
}
