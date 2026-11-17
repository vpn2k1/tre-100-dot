import 'package:flutter/material.dart';

import '../game/puzzle.dart';
import '../game/route_check.dart';
import '../strings.dart';
import '../theme.dart';
import 'bamboo_tile_image.dart';
import 'widgets.dart';

class BambooBoard extends StatelessWidget {
  const BambooBoard({
    super.key,
    required this.puzzle,
    required this.result,
    required this.onTap,
    required this.onLongPress,
  });

  final Puzzle puzzle;
  final RouteResult result;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onLongPress;

  Color _cellColor(bool lit) {
    if (lit) return const Color(0xFFDAE8BC);
    return const Color(0xFFF4EDCE);
  }

  String _endTag(int index) {
    if (index == puzzle.start) return Strings.tagStart;
    return Strings.tagEnd;
  }

  Widget _onceTag(BambooTile tile) {
    if (tile.rotations == 0) return tagBadge(Strings.onceMark, forest);
    return tagBadge(Strings.onceUsed, Colors.red);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: forest.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFD5B976), width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x330B3226),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: puzzle.size,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemCount: puzzle.cells.length,
      itemBuilder: (context, index) => _cell(index),
    ),
  );

  Widget _cell(int index) {
    final tile = puzzle.cells[index];
    final lit = result.connected.contains(index);
    final isEnd = index == puzzle.start || index == puzzle.finish;
    return Semantics(
      label: Strings.cellLabel(
        index,
        locked: tile.locked,
        gold: tile.goldTile,
        empty: tile.piece == Piece.empty,
      ),
      button: true,
      child: InkWell(
        onTap: () => onTap(index),
        onLongPress: () => onLongPress(index),
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _cellColor(lit),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BambooTileImage(tile.mask, golden: tile.goldTile),
              ),
              if (tile.piece == Piece.empty && puzzle.heldTile != null)
                const Center(
                  child: Icon(Icons.add_circle_outline, color: forest),
                ),
              if (isEnd)
                Positioned(
                  left: 3,
                  top: 3,
                  child: tagBadge(_endTag(index), forest),
                ),
              if (tile.locked && !isEnd)
                const Positioned(
                  right: 4,
                  top: 3,
                  child: Icon(Icons.lock, size: 16, color: forest),
                ),
              if (tile.once)
                Positioned(right: 3, bottom: 3, child: _onceTag(tile)),
            ],
          ),
        ),
      ),
    );
  }
}
