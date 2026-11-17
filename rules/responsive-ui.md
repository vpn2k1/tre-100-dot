# Kích thước giao diện theo khung

Dự án không dùng package ngoài (xem [CLAUDE.md](../CLAUDE.md)), nên không dùng `.r` hay `.sp`. Thay vào đó:

- Kích thước khối lưới và bản vẽ lấy từ constraint: `AspectRatio`, `LayoutBuilder`, `size.shortestSide`. Không hardcode chiều rộng ô theo pixel.
- Khung ngoài giới hạn `maxWidth: 600` để không kéo giãn trên tablet.
- Cỡ chữ cố định trong `lib/ui/`. Khi đổi, kiểm tra ở màn hình 360 px chiều rộng.
- Không dùng `MediaQuery` để tính kích thước layout chính. Chỉ dùng cho việc đọc padding an toàn (`SafeArea`).

Kiểm tra tự động: không có. Kiểm tra thủ công trên Chrome với cửa sổ hẹp.
