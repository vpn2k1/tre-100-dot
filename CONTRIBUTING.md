# Hướng dẫn đóng góp

## Chuẩn bị môi trường

- Flutter SDK có Dart ≥ 3.3 (dự án đã kiểm tra với Flutter 3.44 stable). `withValues` cần Flutter ≥ 3.27.
- Cài dependency: `flutter pub get`.

## Quy trình

1. Tạo nhánh từ `main`: `git checkout -b feat/ten-tinh-nang` hoặc `fix/ten-loi`.
2. Sửa code theo [CLAUDE.md](CLAUDE.md) và [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
3. Chạy kiểm tra trước khi commit (theo [rules/workflow.md](rules/workflow.md)):

   ```bash
   dart format lib test
   flutter analyze
   flutter test
   ```

4. Chạy thử trên thiết bị hoặc Chrome để kiểm tra giao diện, đặc biệt khi đổi `lib/ui/game_page.dart` hoặc `lib/ui/bamboo_painter.dart`.
5. Cập nhật [CHANGELOG.md](CHANGELOG.md) nếu thay đổi hành vi người chơi thấy được.
6. Commit theo định dạng bên dưới rồi mở PR.

## Định dạng commit

Dùng [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: thêm bộ chọn màn
fix: sửa điều kiện thắng khi có đốt vàng
test: thêm test cho checkRoute
docs: cập nhật README
refactor: tách PuzzleFactory sang file riêng
```

## Yêu cầu cho PR

- `dart format` không đổi gì thêm, `flutter analyze` không có lỗi hay cảnh báo mới.
- `flutter test` pass, gồm rule về toán tử 3 ngôi và số dòng mỗi file.
- Thay đổi logic sinh màn hoặc kiểm tra thắng phải có test.
- Nếu đổi công thức sinh màn, ghi rõ trong mô tả PR là các màn cũ sẽ thay đổi.

## Báo lỗi

Mở issue với các thông tin: số màn, thao tác để tái hiện, thiết bị và phiên bản Flutter (`flutter --version`).
