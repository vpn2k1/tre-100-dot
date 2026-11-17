# Kiến trúc

## Tổng quan

Code nằm trong `lib/`, chia theo lớp:

| File | Vai trò |
|---|---|
| `main.dart` | Điểm vào, `BambooGameApp` (`MaterialApp`, theme Material 3, `colorSchemeSeed: leaf`) |
| `theme.dart` | Màu thương hiệu |
| `strings.dart` | Mọi chuỗi giao diện (`Strings`) |
| `game/puzzle.dart` | Model (`Piece`, `BambooTile`, `Puzzle`), bitmask, `PuzzleFactory.build(level)` sinh màn đã giải được |
| `game/route_check.dart` | `checkRoute(puzzle)` kiểm tra thắng bằng BFS, trả về `RouteResult` |
| `ui/game_page.dart` | `GamePage` / `_GamePageState`: màn hình chính, chạm, lượt xoay, popup |
| `ui/bamboo_tile_image.dart` | Hiển thị ảnh PNG đốt tre theo bitmask |
| `ui/bamboo_board.dart` | Bàn chơi, nhãn và thao tác trên từng ô |
| `ui/widgets.dart` | Nền, đầu trang, thẻ thông tin và nhãn dùng lại |

Lớp `game/` không import Flutter UI (trừ `package:flutter` không dùng tới), nên test được không cần widget. Không có state management ngoài. Trạng thái nằm trong `_GamePageState` và gọi `setState`.

## Biểu diễn hướng

Mỗi ô có một `mask` 4 bit: `1` = Bắc, `2` = Đông, `4` = Nam, `8` = Tây (`dirs`).

- `rotateMask(mask)` xoay 90° theo chiều kim đồng hồ.
- `rotateTimes(mask, times)` xoay nhiều lần.
- Hai ô nối với nhau khi ô A có bit hướng về B và ô B có bit hướng ngược lại (`k` và `(k + 2) % 4`).

## Sinh màn

1. Kích thước lưới: level 1–5 là 3×3, 6–15 là 4×4, 16–30 là 5×5 (`gridSizeFor`).
2. Seed là `681 + level * 1109`, nên mỗi màn luôn giống nhau.
3. DFS ngẫu nhiên từ ô 0 đến ô cuối, thử tối đa 260 lần. Đường đi phải có độ dài trong khoảng 55%–92% số ô.
4. Nếu DFS thất bại, dùng đường "bậc thang" cố định làm dự phòng.
5. Các ô trên đường có hướng đúng sẵn. Sau đó chúng được xoay ngẫu nhiên 1–3 lần, hoặc bị khóa, hoặc là ô `once`.
6. Ô `once` (level ≥ 16) bắt đầu lệch đúng một lần xoay theo chiều kim đồng hồ, tức là `turns = 3`. Người chơi chỉ được chạm đúng một lần.
7. Ô khóa (level 6–15) không xoay được.
8. Màn đặc biệt (level chia hết cho 5, hoặc 30) có tối đa 3 đốt vàng bắt buộc đi qua. Đốt vàng không bao giờ là ô đầu hoặc ô cuối.
9. Các ô ngoài đường được sinh ngẫu nhiên, có thể là ô trống, đốt thẳng, cong hoặc ngã ba. Chúng có thể tạo thêm đường nối nhưng không ảnh hưởng đến lời giải.
10. Từ màn 3, đốt giữa của tuyến được tách ra và đặt vào tay người chơi. Có thể ghép vào ô trống, hoặc nhấn giữ một đốt không khóa để tách ra; tay chỉ chứa một đốt.

Giới hạn lượt: `n * n * 5`. Xoay, tách và ghép đều tốn một lượt.

## Kiểm tra thắng

`checkRoute` là BFS trên trạng thái `(vị_trí, tập_đốt_vàng_đã_qua)`. Với tối đa 3 đốt vàng, số trạng thái nhỏ, nên BFS chạy nhanh. Thắng khi tới ô đích với đủ mọi đốt vàng và tay không còn giữ đốt tre. Hàm này trả về tập ô đã nối từ S, dùng để tô sáng.

## Vẽ

- Mỗi ô là một `InkWell` chứa `DecoratedBox` và ảnh PNG nền trong suốt.
- Ảnh tre được xoay theo bitmask; đốt vàng dùng bộ lọc màu. Ảnh chụp rặng tre nằm sau giao diện.

## Hướng mở rộng

Nếu game lớn lên, có thể tách tiếp `ui/` theo màn hình và đưa thêm model vào `game/`. Logic thuần Dart phải được test không cần widget.
