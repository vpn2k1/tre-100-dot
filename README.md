# 🎋 100 Đốt Tre – Nối Đường

Prototype Flutter game **Connect Puzzle + Logic** bằng tiếng Việt, không cần package ngoài. Code nằm trong `lib/` (xem [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)).

## Chạy game

1. Cài Flutter SDK bản có Dart >= 3.3.
2. Ở thư mục project chạy:

```bash
flutter pub get
flutter run
```

Nếu muốn thêm Android/iOS/Web platform vào thư mục nguồn (ZIP này không chứa file sinh sẵn của Flutter):

```bash
flutter create --project-name mot_tram_dot_tre --platforms=android,ios,web .
flutter pub get
flutter run -d chrome
```

## Đã có

- 30 màn được tạo ổn định từ seed theo số màn.
- Màn 1–5: 3×3; 6–15: 4×4 với ô khóa; 16–30: 5×5 với các ô chỉ xoay một lần.
- Màn đặc biệt 5, 10, 15, 20, 25, 30 có đốt tre vàng bắt buộc.
- Chạm xoay 90 độ; từ màn 3, chạm ô trống để Khắc nhập đốt đang cầm, nhấn giữ đốt không khóa để Khắc xuất. Mỗi thao tác tính một lượt.
- Thắng khi đường nối từ S đến Đ đi qua mọi đốt vàng và tay không còn đốt tre. Có giới hạn lượt, chơi lại, qua màn và popup thắng/thua.
- Kiểm tra kết nối hai chiều theo hướng và tất cả điểm vàng bằng BFS trạng thái `(ô, tập điểm vàng)`.
- Đồ họa tre dùng ảnh PNG nền trong suốt với chất liệu tre thật; các ảnh được xoay theo hướng đường nối.
- Giao diện dùng ảnh chụp rặng tre làm nền, các thẻ nền sáng và khung bàn chơi màu tre để giữ chữ và đường nối dễ đọc.
- `assets/bamboo/` chứa ảnh tre thẳng, cong, ngã ba và đầu tre. Đốt vàng dùng ảnh tre thật với bộ lọc màu.

## Lưu ý

Đây là prototype; chưa có âm thanh, hoạt cảnh thắng, lưu tiến độ, bộ chọn màn, monetization.
