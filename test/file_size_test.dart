import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Quy tắc: rules/file-size.md.
// Đếm dòng không trống và không phải comment `//`.
const maxLines = 300;

// Mức trần cho file cũ đã vượt quy tắc. Chỉ được giảm, không được tăng.
const legacyCeilings = <String, int>{};

int codeLines(File file) => file.readAsLinesSync().where((line) {
      final trimmed = line.trim();
      return trimmed.isNotEmpty && !trimmed.startsWith('//');
    }).length;

String relativePath(File file) =>
    file.path.replaceAll('\\', '/').replaceFirst(RegExp(r'^.*?(?=lib/)'), '');

void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('Mỗi file dưới 300 dòng code (trừ file trong legacyCeilings)', () {
    for (final file in files) {
      final path = relativePath(file);
      final limit = legacyCeilings[path] ?? maxLines;
      expect(
        codeLines(file),
        lessThanOrEqualTo(limit),
        reason: '$path vượt $limit dòng, xem rules/file-size.md',
      );
    }
  });

  test(
    'Mức trần legacy khớp số dòng hiện tại (hạ mức trần khi file nhỏ đi)',
    () {
      for (final entry in legacyCeilings.entries) {
        final file =
            files.where((f) => relativePath(f) == entry.key).firstOrNull;
        expect(
          file,
          isNotNull,
          reason: '${entry.key} không còn tồn tại, xóa khỏi legacyCeilings',
        );
        expect(
          codeLines(file!),
          equals(entry.value),
          reason: 'Đặt legacyCeilings["${entry.key}"] = ${codeLines(file)}',
        );
      }
    },
  );
}
