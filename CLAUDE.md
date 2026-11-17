# CLAUDE.md – Hướng dẫn cho AI agent

Dự án: **100 Đốt Tre – Nối Đường**, prototype game puzzle Flutter, UI tiếng Việt, không dùng package ngoài.

Đọc thêm: [README.md](README.md) (chạy game), [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (kiến trúc và thuật toán), [docs/RULES.md](docs/RULES.md) (lý do các rule), [CONTRIBUTING.md](CONTRIBUTING.md) (quy trình).

## Rules (bắt buộc)

@rules/no-ternary.md
@rules/file-size.md
@rules/localization.md
@rules/responsive-ui.md
@rules/workflow.md

## Lệnh thường dùng

```bash
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run
```

Trước khi báo hoàn thành, phải chạy `dart format`, `flutter analyze` và `flutter test` theo [rules/workflow.md](rules/workflow.md). Báo lại kết quả thật, kể cả khi có lỗi.

## Cấu trúc

- `lib/main.dart`: điểm vào, `BambooGameApp`.
- `lib/theme.dart`: màu thương hiệu dùng chung.
- `lib/strings.dart`: mọi chuỗi giao diện (`Strings`).
- `lib/game/puzzle.dart`: model, bitmask, `PuzzleFactory` (sinh màn).
- `lib/game/route_check.dart`: `checkRoute` (BFS kiểm tra thắng).
- `lib/ui/game_page.dart`: màn hình chính và xử lý chạm.
- `lib/ui/bamboo_tile_image.dart`: hiển thị và xoay ảnh tre PNG theo bitmask.
- `lib/ui/bamboo_board.dart`: bàn chơi và thao tác trên ô tre.
- `lib/ui/widgets.dart`: widget nhỏ dùng lại (ô thống kê, nhãn).
- `test/`: `widget_test.dart` (sinh màn, bitmask), `no_ternary_test.dart` và `file_size_test.dart` (kiểm tra rule tự động).
- `assets/bamboo/`: ảnh tre PNG nền trong suốt, khai báo trong `pubspec.yaml`.

## Quy tắc khi sửa code

- Mỗi file dưới 300 dòng code (rule trong `rules/file-size.md`). Khi thêm code, tách theo trách nhiệm trước khi vượt.
- Không thêm package ngoài khi chưa được hỏi. Ghi rõ trong báo cáo nếu cần.
- Không đổi seed sinh màn (`681 + level * 1109`) hoặc công thức sinh nếu không có yêu cầu. Đổi chúng sẽ làm mọi màn đã thiết kế thay đổi.
- Bitmask hướng: N=1, E=2, S=4, W=8. Xoay một lần theo chiều kim đồng hồ là `rotateMask`. Đừng đảo thứ tự.
- Màu thương hiệu khai báo trong `lib/theme.dart`. Dùng lại các hằng số này thay vì mã màu rải rác.
- Chuỗi giao diện đi qua `Strings`. Giữ tiếng Việt có dấu.
- Mọi thay đổi logic màn chơi phải có test trong `test/`.
- Dùng `withValues(alpha: ...)`, không dùng `withOpacity` (đã deprecated).

## Quy tắc về git và file sinh

- Không commit `build/`, `.dart_tool/`, `.DS_Store`.
- Không tự commit hoặc push khi người dùng chưa yêu cầu.
- Không sửa `pubspec.lock` bằng tay. Dùng `flutter pub get`.

## Bối cảnh khác

- Dự án là prototype. Chưa có âm thanh, lưu tiến độ, bộ chọn màn, hay monetization. Đừng tự thêm các tính năng này.
- Ngôn ngữ trao đổi với người dùng: tiếng Việt.
