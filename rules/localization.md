# Chuỗi giao diện qua `Strings`

Mọi chuỗi người chơi thấy, gồm tiêu đề, nhãn, gợi ý, nội dung popup và nhãn Semantics, khai báo trong `lib/strings.dart` (class `Strings`). Widget chỉ tham chiếu `Strings.xxx`.

- Chuỗi cố định: `static const`.
- Chuỗi có tham số: `static String` hàm, ví dụ `Strings.winBody(level, moves)`.
- Không đặt chuỗi tiếng Việt trực tiếp trong `lib/ui/` hoặc `lib/game/`, trừ khi là dữ liệu kỹ thuật (tên hướng, mã kiểu).
- Giữ dấu tiếng Việt đầy đủ.

Kiểm tra tự động: không có. Khi review, tìm chuỗi có dấu trong `lib/` ngoài `strings.dart`.
