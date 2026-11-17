# Không dùng toán tử 3 ngôi

Không viết `điều_kiện ? a : b` trong `lib/` và `test/`. Dùng `if` và `return` hoặc biến tạm.

```dart
// Sai
final piece = index == start ? Piece.end : Piece.bend;

// Đúng
Piece _pieceAt(int index) {
  if (index == start) return Piece.end;
  return Piece.bend;
}
```

Áp dụng cả trong chuỗi nội suy: `'${locked ? 'khóa' : 'mở'}'` cũng sai. Tách thành hàm trả về chuỗi.

Không tính là toán tử 3 ngôi: `?.`, `??`, `??=`, kiểu nullable `String?`.

Kiểm tra tự động: `test/no_ternary_test.dart`. Chạy `dart format` trước khi chạy test.
