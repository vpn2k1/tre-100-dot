---
name: verify-flutter
description: Kiểm tra chất lượng dự án 100 Đốt Tre (analyze, test, kiểm tra màn). Dùng sau mỗi thay đổi code hoặc khi người dùng hỏi "kiểm tra dự án".
---

# Kiểm tra dự án Flutter

Chạy từ thư mục gốc dự án.

## Các bước

1. Lấy dependency nếu chưa có: `flutter pub get`.
2. Định dạng: `dart format lib test`. Theo [rules/workflow.md](../../../rules/workflow.md), bước này phải chạy trước test.
3. Phân tích tĩnh: `flutter analyze`. Báo mọi lỗi và cảnh báo mới.
4. Test: `flutter test`. Báo số test pass/fail và đính kèm lỗi nếu có. Gồm cả `no_ternary_test` và `file_size_test` (xem [docs/RULES.md](../../../docs/RULES.md)).
5. Nếu đổi logic sinh màn hoặc `checkRoute`, chạy lại test và kiểm tra thêm:
   - Mọi màn 1–30 có đủ ô, ô đầu/cuối có mask khác 0, màn 5/10/15/20/25/30 có đốt vàng.
   - Với mọi màn, đường từ S đến Đ tồn tại khi mọi ô trên đường ở đúng hướng (xem [docs/ARCHITECTURE.md](../../../docs/ARCHITECTURE.md)).
6. Báo kết quả theo mẫu:
   - Analyze: số lỗi/cảnh báo
   - Test: số pass/fail
   - Không kiểm tra được: liệt kê rõ (ví dụ layout trên thiết bị)

Không sửa code trong skill này. Nếu phát hiện lỗi, báo lại và hỏi người dùng có muốn sửa không.
