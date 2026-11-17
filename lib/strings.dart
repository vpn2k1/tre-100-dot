/// Chuỗi hiển thị cho người chơi. Mọi chuỗi giao diện đi qua đây (xem rules/localization.md).
abstract final class Strings {
  static const appTitle = '100 Đốt Tre – Nối Đường';
  static const gameTitle = '100 ĐỐT TRE';
  static const gameSubtitle = 'NỐI ĐƯỜNG';
  static const statusLevel = 'MÀN CHƠI';
  static const statusMoves = 'LƯỢT CHƠI';
  static const statusGrid = 'LƯỚI';
  static const specialHint =
      '✨ Màn đặc biệt: đường nối phải đi qua mọi đốt tre vàng.';
  static const easyHint = 'Chạm từng đốt tre để xoay. Nối từ S đến Đ.';
  static const lockHint = '🔒 Ô có khóa không thể xoay. Nối từ S đến Đ.';
  static const onceHint =
      '↻ Ô đánh dấu ① chỉ được xoay một lần. Nối từ S đến Đ.';
  static const winTitle = '🎋 Khắc nhập! Khắc nhập!';
  static const loseTitle = 'Hết lượt xoay!';
  static const retry = 'Chơi lại';
  static const nextLevel = 'Màn tiếp theo';
  static const nextShort = 'Màn tiếp';
  static const legend = 'Đường sáng: đã nối từ S  •  Đốt vàng: bắt buộc đi qua';
  static const tagStart = 'S';
  static const tagEnd = 'Đ';
  static const onceMark = '①';
  static const onceUsed = '×';
  static const detachTitle = 'KHẮC XUẤT';
  static const detachHint = 'Nhấn giữ đốt tre để tách ra.';
  static const attachTitle = 'KHẮC NHẬP';
  static const attachHint = 'Chạm ô trống để ghép đốt tre vào.';

  static String winBody(int level, int moves) =>
      'Bạn đã nối thành công đường tre ở màn $level sau $moves lượt!';

  static String loseBody(int level) =>
      'Hãy thử lại màn $level để tìm đường tre đúng.';

  static String gridSize(int n) => '$n × $n';

  static String cellLabel(
    int index, {
    required bool locked,
    required bool gold,
    required bool empty,
  }) => 'Ô ${index + 1}, ${_tileState(locked, empty)}, ${_goldState(gold)}';

  static String _tileState(bool locked, bool empty) {
    if (empty) return 'ô trống';
    if (locked) return 'bị khóa';
    return 'có thể xoay';
  }

  static String _goldState(bool gold) {
    if (gold) return 'đốt vàng';
    return 'đốt thường';
  }
}
