# Mỗi file dưới 300 dòng code

Một file trong `lib/` hoặc `test/` không vượt 300 dòng code. Dòng trống và dòng `//` không tính.

Khi file sắp vượt, tách theo trách nhiệm trước khi thêm code:

- Model và thuật toán thuần Dart (`PuzzleFactory`, `checkRoute`) tách khỏi widget.
- Widget con có tái sử dụng đưa sang file riêng.
- Chuỗi UI đi vào `lib/strings.dart` (xem [localization.md](localization.md)).

File cũ đã vượt quy tắc được ghi trong `legacyCeilings` của `test/file_size_test.dart`. Mức trần chỉ được giảm. Khi tách file, cập nhật lại mức trần cho đúng số dòng mới.

Kiểm tra tự động: `test/file_size_test.dart`.
