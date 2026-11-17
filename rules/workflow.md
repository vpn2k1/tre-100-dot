# Quy trình sau khi sửa code

Sau mỗi thay đổi trong `lib/` hoặc `test/`, chạy theo thứ tự:

1. `dart format lib test`. Bắt buộc, vì test không ghi toán tử 3 ngôi phụ thuộc vào định dạng.
2. `flutter analyze`. Không để lỗi mới. Cảnh báo mới cũng phải sửa.
3. `flutter test`. Mọi test pass.

Báo lại kết quả thật của từng bước. Nếu bước nào không chạy được, nói rõ lý do.

Chỉ sửa các file liên quan đến thay đổi. Không chạy `dart format` lên file không đổi để tránh diff thừa.
