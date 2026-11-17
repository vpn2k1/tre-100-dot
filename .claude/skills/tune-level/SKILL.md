---
name: tune-level
description: Thêm hoặc chỉnh một quy tắc sinh màn trong dự án 100 Đốt Tre (kích thước lưới, khóa, ô một lần, đốt vàng). Dùng khi người dùng muốn đổi độ khó hoặc thêm cơ chế cho các màn.
---

# Chỉnh độ khó màn chơi

Các quy tắc nằm trong `PuzzleFactory.build` ([lib/game/puzzle.dart](../../../lib/game/puzzle.dart)). Đọc [docs/ARCHITECTURE.md](../../../docs/ARCHITECTURE.md) phần "Sinh màn" trước khi sửa.

## Quy trình

1. Xác định phạm vi thay đổi: chỉ một cụm level, hay toàn bộ 30 màn?
2. Sửa điều kiện trong `build` (ví dụ `level >= 6 && level <= 15`). Không đổi seed `681 + level * 1109` trừ khi người dùng yêu cầu rõ, vì làm vậy đổi mọi màn.
3. Nếu thêm cơ chế mới, cập nhật:
   - Chuỗi gợi ý trong `build` của `GamePage` (`isSpecial` và các nhánh `level <= 5`, `<= 15`).
   - Phương thức `_cell` trong [lib/ui/game_page.dart](../../../lib/ui/game_page.dart) để người chơi nhận ra ô mới.
   - Test trong `test/widget_test.dart`.
4. Chạy skill `verify-flutter` (analyze + test).
5. Báo cho người dùng: màn nào thay đổi, và có màn cũ nào bị đổi kết quả không.

## Lưu ý

- Các ô khóa và ô một lần chỉ tạo ở level ≥ 6 hoặc ≥ 16. Đừng đưa chúng xuống màn đầu nếu không có yêu cầu.
- Màn đặc biệt là level chia hết cho 5 hoặc level 30. Mỗi màn này phải có đốt vàng.
- Giới hạn lượt hiện là `n * n * 5`. Nếu đổi, kiểm tra các màn 5×5 vẫn có thể thắng với lượt tối đa theo lý thuyết.
