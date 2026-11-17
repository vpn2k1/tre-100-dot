import 'dart:math';

import 'package:flutter/material.dart';

import '../game/puzzle.dart';
import '../game/route_check.dart';
import '../strings.dart';
import '../theme.dart';
import 'bamboo_board.dart';
import 'widgets.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int level = 1;
  late Puzzle puzzle;
  late RouteResult result;
  int moves = 0;
  bool finished = false;
  bool failed = false;

  @override
  void initState() {
    super.initState();
    _load(1);
  }

  void _load(int next) {
    level = max(1, min(30, next));
    puzzle = PuzzleFactory.build(level);
    result = checkRoute(puzzle);
    moves = 0;
    finished = false;
    failed = false;
  }

  void _tap(int index) {
    if (finished || failed) return;
    final tile = puzzle.cells[index];
    if (tile.piece == Piece.empty) {
      if (puzzle.heldTile == null) return;
      setState(() {
        puzzle.attach(index);
        _recordMove();
      });
    } else {
      if (!tile.canRotate) return;
      setState(() {
        tile.mask = rotateMask(tile.mask);
        tile.rotations++;
        _recordMove();
      });
    }
    _scheduleOutcome();
  }

  void _longPress(int index) {
    if (level < 3 || finished || failed || puzzle.heldTile != null) return;
    if (puzzle.cells[index].piece == Piece.empty ||
        puzzle.cells[index].locked) {
      return;
    }
    setState(() {
      puzzle.detach(index);
      _recordMove();
    });
    _scheduleOutcome();
  }

  void _recordMove() {
    moves++;
    result = checkRoute(puzzle);
    finished = result.won;
    failed = !finished && moves >= puzzle.maxMoves;
  }

  void _scheduleOutcome() {
    if (finished || failed) {
      Future<void>.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        _showOutcome();
      });
    }
  }

  void _goNext() => setState(() => _load(level + 1));

  VoidCallback? _nextAction() {
    if (level >= 30) return null;
    return _goNext;
  }

  void _showOutcome() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cream,
        title: Text(_outcomeTitle()),
        content: Text(_outcomeBody()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _load(level));
            },
            child: const Text(Strings.retry),
          ),
          if (finished && level < 30)
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => _load(level + 1));
              },
              child: const Text(Strings.nextLevel),
            ),
        ],
      ),
    );
  }

  String _outcomeTitle() {
    if (finished) return Strings.winTitle;
    return Strings.loseTitle;
  }

  String _outcomeBody() {
    if (finished) return Strings.winBody(level, moves);
    return Strings.loseBody(level);
  }

  String _hint(bool isSpecial) {
    if (isSpecial) return Strings.specialHint;
    if (level <= 5) return Strings.easyHint;
    if (level <= 15) return Strings.lockHint;
    return Strings.onceHint;
  }

  @override
  Widget build(BuildContext context) {
    final n = puzzle.size;
    final isSpecial = puzzle.goldCount > 0;
    return Scaffold(
      backgroundColor: cream,
      body: bambooBackdrop(
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final boardSize = min(
                    constraints.maxWidth - 36,
                    constraints.maxHeight * .48,
                  );
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          gameHeader(),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              statusChip(Strings.statusLevel, '$level / 30'),
                              const SizedBox(width: 8),
                              statusChip(
                                Strings.statusMoves,
                                '$moves / ${puzzle.maxMoves}',
                              ),
                              const SizedBox(width: 8),
                              statusChip(
                                Strings.statusGrid,
                                Strings.gridSize(n),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          hintCard(_hint(isSpecial)),
                          if (level >= 3) ...[
                            const SizedBox(height: 10),
                            heldTileCard(puzzle.heldTile),
                          ],
                          const SizedBox(height: 16),
                          SizedBox.square(
                            dimension: boardSize,
                            child: BambooBoard(
                              puzzle: puzzle,
                              result: result,
                              onTap: _tap,
                              onLongPress: _longPress,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: cream.withValues(
                                      alpha: .95,
                                    ),
                                    foregroundColor: forest,
                                    side: const BorderSide(color: forest),
                                  ),
                                  onPressed: () => setState(() => _load(level)),
                                  icon: const Icon(Icons.restart_alt),
                                  label: const Text(Strings.retry),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: forest,
                                  ),
                                  onPressed: _nextAction(),
                                  icon: const Icon(Icons.skip_next),
                                  label: const Text(Strings.nextShort),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: cream.withValues(alpha: .88),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              Strings.legend,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: forest),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
