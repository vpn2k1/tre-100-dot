import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Quy tắc: rules/no-ternary.md.
// Dựa vào định dạng của `dart format`: dấu `?` của toán tử 3 ngôi luôn có khoảng trắng
// hai bên, còn `?.`, `??` và kiểu nullable (`String?`) thì không. Chạy dart format trước.
final _ternary = RegExp(r'(^|\s)\?\s');
final _literal = RegExp(
  r"'(?:\\.|[^'\\])*'|"
  r'"(?:\\.|[^"\\])*"',
);
final _interpolation = RegExp(r'\$\{([^}]*)\}');

// Bỏ nội dung chuỗi và comment, nhưng giữ code bên trong `${...}`.
String codeOf(String line) {
  final inside =
      _interpolation.allMatches(line).map((m) => m.group(1)!).join(' ');
  final noStrings = line.replaceAll(_literal, "''");
  final noComment = noStrings.replaceFirst(RegExp(r'//.*$'), '');
  return '$noComment $inside';
}

Iterable<File> dartFiles() sync* {
  for (final dir in ['lib', 'test']) {
    final root = Directory(dir);
    if (!root.existsSync()) continue;
    yield* root
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
  }
}

void main() {
  test('Không dùng toán tử 3 ngôi trong lib/ và test/', () {
    final violations = <String>[];
    for (final file in dartFiles()) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (_ternary.hasMatch(codeOf(lines[i]))) {
          violations.add('${file.path}:${i + 1}');
        }
      }
    }
    expect(
      violations,
      isEmpty,
      reason: 'Thay toán tử 3 ngôi bằng if/else, xem rules/no-ternary.md',
    );
  });
}
