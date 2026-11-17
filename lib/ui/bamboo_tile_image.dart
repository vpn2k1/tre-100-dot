import 'package:flutter/material.dart';

import '../game/puzzle.dart';

class BambooTileImage extends StatelessWidget {
  const BambooTileImage(this.mask, {super.key, this.golden = false});

  final int mask;
  final bool golden;

  @override
  Widget build(BuildContext context) {
    if (mask == 0) return const SizedBox.shrink();

    var baseMask = 1;
    var asset = 'assets/bamboo/tre_dau.png';
    if (mask == 5 || mask == 10) {
      baseMask = 5;
      asset = 'assets/bamboo/tre_thang.png';
    } else if (mask == 3 || mask == 6 || mask == 12 || mask == 9) {
      baseMask = 3;
      asset = 'assets/bamboo/tre_cong.png';
    } else if (mask == 7 || mask == 14 || mask == 13 || mask == 11) {
      baseMask = 7;
      asset = 'assets/bamboo/tre_nga_ba.png';
    }

    var turns = 0;
    while (turns < 4 && rotateTimes(baseMask, turns) != mask) {
      turns++;
    }

    Widget image = Image.asset(
      asset,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
    );
    if (golden) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color(0xFFE3B546),
          BlendMode.hue,
        ),
        child: image,
      );
    }
    return RotatedBox(quarterTurns: turns, child: image);
  }
}
