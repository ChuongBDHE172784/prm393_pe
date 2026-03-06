# ZenFit – Ứng dụng Đăng ký & Quản lý Gói tập Gym (Flutter Front-end)

Dự án này hiện thực đề tài: **Hệ thống Đăng ký & Quản lý Gói tập Gym thông minh “ZenFit”** bằng Flutter (chỉ front‑end, không có backend).

## 1. Thông tin cấu hình & công nghệ

- **Nền tảng build**: Windows Desktop, Web, Android (một codebase Flutter)
- **State management**: `Provider` với `ChangeNotifier` (`lib/state/zenfit_state.dart`)
- **Ngôn ngữ code**: Dart (Flutter), Android host dùng Kotlin (mặc định của Flutter)
- **Ngôn ngữ hiển thị trong app**: English (đúng yêu cầu đề)
- **Tài nguyên (assets)**:
  - `assets/student_info.json`: chứa `name`, `student_id`, `email` để hiển thị ở màn Splash
  - `assets/ai_prompt_history.json`: chứa danh sách lịch sử prompt/response AI theo đúng format đề bài

## 2. Luồng màn hình (8 màn)

### Splash (Màn 0)
- Đọc file `assets/student_info.json`.
- Hiển thị: tên, mã số sinh viên, email và logo “ZenFit”.
- Đợi đúng **5 giây**, sau đó tự động điều hướng sang **Màn 1 – Profile Setup**.

### Màn 1 – Profile Setup
- Nhập:
  - Họ tên (Full name)
  - Ngày sinh (Date of birth)
  - Giới tính (Gender)
  - Cân nặng (Weight kg)
  - Chiều cao (Height cm)
- Ràng buộc:
  - Cân nặng, chiều cao phải là **số dương**.
- **BMI** được tính tự động và hiển thị khi đã nhập đủ cân nặng + chiều cao hợp lệ.
- Nút **`Tiếp tục`** → chuyển sang **Màn 2 – Plan Selection**.

### Màn 2 – Plan Selection
- Danh sách gói:
  - Basic (500k)
  - Premium (1tr)
  - VIP (2tr)
- Logic:
  - Nếu **BMI > 30** (béo phì):
    - Hiển thị cảnh báo sức khỏe, khuyên chọn **Premium** hoặc **VIP**.
    - Nếu người dùng chọn **Basic**, nút **`Tiếp tục`** sẽ **bị disable** kèm giải thích.
  - Nếu BMI ≤ 30 thì có thể chọn bất kỳ gói nào.
- Nút **`Tiếp tục`** → **Màn 3 – Payment & Promo**.

### Màn 3 – Payment & Promo
- Nhập mã giảm giá (Promo code).
- Quy tắc:
  - Mã `GIAM50`: chỉ áp dụng nếu **tổng tiền > 1.500.000 VND** (1.5tr) → giảm 50% giá gói.
  - Mã `TANTHU`: chỉ áp dụng nếu người dùng **dưới 22 tuổi** (tính từ ngày sinh ở Màn 1) → giảm 100.000 VND.
- Màn hình hiển thị:
  - Subtotal (tổng trước khuyến mãi)
  - Các dòng discount (GIAM50, TANTHU nếu đủ điều kiện)
  - Final total (tổng sau giảm giá)
- Nút **`Tiếp tục`** → **Màn 4 – Review & Confirm**.

### Màn 4 – Review & Confirm
- Hiển thị tóm tắt toàn bộ thông tin:
  - Thông tin cá nhân: họ tên, tuổi, giới tính, cân nặng, chiều cao, BMI.
  - Thông tin gói tập + khuyến mãi: gói, mã giảm giá, subtotal, discount, final total.
- Cho phép **quay lại sửa**:
  - Nút “Edit profile” → quay lại **Màn 1**.
  - Nút “Edit plan & promo” → quay lại **Màn 2** (từ đó có thể đi lại Màn 3).
- Yêu cầu đề bài:
  - Nếu quay lại sửa **chiều cao** ở Màn 1 làm BMI thay đổi thì **Màn 2 và 3 phải tự cập nhật logic** (béo phì / không, áp dụng GIAM50/TANTHU…).
  - Việc này được đảm bảo vì mọi dữ liệu/bmi/age/promo đều nằm trong `ZenFitState` (Provider) dùng chung.
- Nút **Confirm & continue** → **Màn 5 – Dashboard**.

### Màn 5 – Member Dashboard
- Hiển thị **thẻ thành viên ảo**:
  - ZenFit Member
  - Họ tên (ưu tiên tên nhập ở Màn 1, nếu rỗng thì dùng `student_name` từ JSON)
  - Student ID
  - Gói đã chọn
  - Số tiền cuối cùng đã thanh toán (sau giảm giá)
- Nút **`Hết bài làm`** → chuyển sang **Màn 6 – AI Prompt History**.

### Màn 6 – AI Prompt History
- Đọc file `assets/ai_prompt_history.json` với cấu trúc mà đề yêu cầu:
  ```json
  [
    {
      "date": "2026-03-04",
      "time": "14:30:15",
      "sender": "user account name",
      "receiver": "AI assistant name",
      "prompt": "<question>",
      "response": "<answer>"
    }
  ]
  ```
- Dùng `ListView.separated` để hiển thị danh sách:
  - Mỗi item: thời gian (date + time) + tiêu đề ngắn (rút gọn từ prompt).
- Khi bấm vào 1 item → điều hướng sang **Màn 7 – AI Response Detail**.

### Màn 7 – AI Response Detail
- Hiển thị:
  - Thời gian
  - Câu hỏi đầy đủ (prompt)
  - Câu trả lời đầy đủ của AI (response)
- Bấm back sẽ quay lại danh sách ở **Màn 6**.

## 3. State management (Provider)

File `lib/state/zenfit_state.dart` là trung tâm lưu trữ state:

- Thông tin từ `student_info.json`: `studentName`, `studentId`, `studentEmail`.
- Thông tin hồ sơ: họ tên, ngày sinh, giới tính, cân nặng, chiều cao.
- Giá trị tính toán:
  - `bmi` (BMI)
  - `age` (tuổi)
  - `isObesity` (BMI > 30)
- Gói tập đã chọn: `selectedPlan` (enum `GymPlan`).
- Thông tin khuyến mãi:
  - `promoCode`
  - Cờ `promoGiam50Applied`, `promoTanThuApplied`
- Tính tiền:
  - `totalBeforePromo` – giá gói
  - `discountAmount` – tổng tiền giảm
  - `finalPrice` – tổng tiền cuối cùng sau giảm

App được bọc `ChangeNotifierProvider` ở `lib/main.dart` với widget gốc là `ZenFitApp`.  
Nhờ đó, chạy lại các màn (Back/Next) luôn dùng chung state, đảm bảo logic liên thông giữa các màn như đề yêu cầu.

## 4. Cách chạy dự án

Tại thư mục gốc dự án:

```bash
flutter pub get
```

### Chạy trên Windows Desktop

```bash
flutter run -d windows
```

### Chạy trên Web (Chrome)

```bash
flutter run -d chrome
```

### Chạy trên Android

1. Mở emulator Android hoặc cắm điện thoại thật (bật USB debugging).
2. Chạy:

```bash
flutter run -d android
```

## 5. Trước khi nộp bài

Theo yêu cầu đề: cần **clean project** trước khi nộp.

- Trong **Android Studio**:
  - Vào menu: `Tools > Flutter > Flutter clean`

Hoặc dùng terminal:

```bash
flutter clean
```

Sau đó có thể nén thư mục dự án và nộp theo đúng hướng dẫn của môn học.
