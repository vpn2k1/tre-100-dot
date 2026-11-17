import 'package:flutter/material.dart';

import 'strings.dart';
import 'theme.dart';
import 'ui/game_page.dart';

void main() => runApp(const BambooGameApp());

class BambooGameApp extends StatelessWidget {
  const BambooGameApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appTitle,
        theme: ThemeData(
            useMaterial3: true, colorSchemeSeed: leaf, fontFamily: 'Roboto'),
        home: const GamePage(),
      );
}
