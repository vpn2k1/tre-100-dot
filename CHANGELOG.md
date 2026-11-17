# Changelog

Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/). Phiên bản theo [SemVer](https://semver.org/lang/vi/).

## [Chưa phát hành]

### Thêm
- Bộ tài liệu cho dự án: `CLAUDE.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `docs/ARCHITECTURE.md`, `docs/RULES.md`.
- Thư mục `rules/` (không toán tử 3 ngôi, file dưới 300 dòng, chuỗi qua `Strings`, kích thước theo constraint, quy trình sau khi sửa) và hai test tự động kiểm tra hai rule đầu.
- Skill `.claude/skills/verify-flutter` và `.claude/skills/tune-level`.
- `lib/strings.dart`: toàn bộ chuỗi giao diện.

### Thay đổi
- Tách `lib/main.dart` thành `lib/game/`, `lib/ui/`, `lib/theme.dart`, `lib/strings.dart` để mọi file dưới 300 dòng.
- Bỏ toán tử 3 ngôi trong code; không còn cảnh báo `withOpacity`, thay bằng `withValues`.
- Định dạng toàn bộ code bằng `dart format`.

## [1.0.0]

### Thêm
- 30 màn sinh ổn định theo số màn, chia 3 cụm kích thước lưới (3×3, 4×4, 5×5).
- Ô khóa (màn 6–15) và ô chỉ xoay một lần (màn 16–30).
- Màn đặc biệt 5, 10, 15, 20, 25, 30 có đốt tre vàng bắt buộc đi qua.
- Giới hạn lượt xoay, nút chơi lại, qua màn, popup thắng/thua.
- Đồ họa tre bằng `CustomPainter`.
- Tài nguyên SVG tham khảo trong `assets/bamboo/`.
