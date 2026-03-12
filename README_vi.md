# Monopoly Ant - Trò chơi Cờ Tỷ Phú

Một trò chơi board game đa nền tảng được phát triển bằng **Flutter** cho di động (iOS & Android). Monopoly Ant được thiết kế để chơi offline, hoàn hảo cho các nhóm đi du lịch và gia đình.

## 🚀 Tính năng
*   **Chơi nhiều người (Pass & Play):** 2-4 người chơi trên cùng một thiết bị.
*   **Chế độ Offline:** Không cần kết nối internet.
*   **Kích thước bàn cờ linh hoạt:** Chọn giữa các cấu hình bàn cờ Nhỏ, Trung bình, Lớn hoặc Rất lớn (MVP hiện tại sử dụng mức Trung bình).
*   **Đa ngôn ngữ:** Hỗ trợ đầy đủ **tiếng Anh** (mặc định) và **tiếng Việt**.
*   **Tự động Lưu & Chơi tiếp:** Tự động lưu tiến trình game, cho phép bạn tiếp tục ván đấu dang dở.
*   **Gameplay năng động:** Mua đất, nâng cấp nhà, thu thuế và thẻ cơ hội.
*   **Hỗ trợ Bot:** Chơi với các đối thủ AI tự động.

## 🛠️ Công nghệ sử dụng
*   **Frontend:** [Flutter](https://flutter.dev/) (SDK ^3.10.7)
*   **Quản lý trạng thái:** [Riverpod](https://riverpod.dev/)
*   **Cơ sở dữ liệu:** [Hive](https://docs.hivedb.dev/) (để lưu dữ liệu offline)
*   **Hiệu ứng (Animations):** [Flutter Animate](https://pub.dev/packages/flutter_animate)
*   **Định danh:** [uuid](https://pub.dev/packages/uuid)

## 📂 Cấu trúc dự án
*   `lib/models/`: Các mô hình dữ liệu và Hive adapters.
*   `lib/providers/`: Logic nghiệp vụ và quản lý trạng thái.
*   `lib/screens/`: Các màn hình chính (Cài đặt, Game).
*   `lib/widgets/`: Các thành phần UI có thể tái sử dụng (Bàn cờ, Ô đất, Bảng người chơi, Nhật ký).
*   `docs/`: Tài liệu chi tiết dự án (PRD, Tổng quan kỹ thuật).

## 📖 Tài liệu
Thông tin chi tiết có thể được tìm thấy trong thư mục `docs/` (Tiếng Anh):
*   [Product Requirements (PRD)](docs/prd.md)
*   [Technical Overview](docs/technical_overview.md)

## 🏗️ Bắt đầu

### Yêu cầu hệ thống
*   Đã cài đặt Flutter SDK.
*   Android Studio / Xcode.

### Cài đặt
1. Clone repository:
   ```bash
   git clone [repository-url]
   ```
2. Di chuyển vào thư mục dự án:
   ```bash
   cd Monopoly-Ant
   ```
3. Cài đặt các thư viện:
   ```bash
   flutter pub get
   ```
4. Tạo mã Hive adapters:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. Chạy ứng dụng:
   ```bash
   flutter run
   ```

## 📜 Bản quyền
Dự án này dành cho mục đích học tập/cá nhân. Vui lòng tham khảo giấy phép của các thư viện bên thứ ba đi kèm.
