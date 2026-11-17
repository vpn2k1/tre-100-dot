import 'package:flutter/material.dart';

import '../game/puzzle.dart';
import '../strings.dart';
import '../theme.dart';
import 'bamboo_tile_image.dart';

Widget bambooBackdrop(Widget child) => Stack(
  children: [
    Positioned.fill(
      child: Image.asset('assets/bamboo/bamboo_grove.jpg', fit: BoxFit.cover),
    ),
    Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cream.withValues(alpha: .42),
              cream.withValues(alpha: .30),
              cream.withValues(alpha: .58),
            ],
          ),
        ),
      ),
    ),
    child,
  ],
);

Widget gameHeader() => Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  decoration: BoxDecoration(
    color: cream.withValues(alpha: .91),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: leaf.withValues(alpha: .55)),
    boxShadow: const [
      BoxShadow(color: Color(0x33233D1F), blurRadius: 14, offset: Offset(0, 6)),
    ],
  ),
  child: Row(
    children: [
      Image.asset(
        'assets/bamboo/tre_thang.png',
        width: 50,
        height: 58,
        fit: BoxFit.fill,
      ),
      const SizedBox(width: 8),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.gameTitle,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: forest,
              ),
            ),
            Text(
              Strings.gameSubtitle,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
                color: Color(0xFF537542),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget hintCard(String text) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: cream.withValues(alpha: .94),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: leaf.withValues(alpha: .55)),
  ),
  child: Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: forest,
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),
  ),
);

Widget heldTileCard(BambooTile? heldTile) {
  Widget preview = const Icon(Icons.front_hand_outlined, color: forest);
  var title = Strings.detachTitle;
  var guidance = Strings.detachHint;
  if (heldTile != null) {
    preview = BambooTileImage(heldTile.mask, golden: heldTile.goldTile);
    title = Strings.attachTitle;
    guidance = Strings.attachHint;
  }
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: cream.withValues(alpha: .96),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD5B976), width: 2),
    ),
    child: Row(
      children: [
        SizedBox(width: 44, height: 44, child: preview),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: forest,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              Text(
                guidance,
                style: const TextStyle(color: forest, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Ô thống kê nhỏ phía trên bàn chơi: nhãn và giá trị.
Widget statusChip(String name, String value) => Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    decoration: BoxDecoration(
      color: cream.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: leaf.withValues(alpha: .4)),
    ),
    child: Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF63805B),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: forest,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  ),
);

/// Nhãn nhỏ đè lên một ô (S, Đ, ①, ×).
Widget tagBadge(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(5),
  ),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
