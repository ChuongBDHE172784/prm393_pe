import 'package:flutter/foundation.dart';
import '../models/gym_plan.dart';

/// Central app state (Provider). Profile, plan, promo, so Screen 4 and BMI logic stay in sync.
class ZenFitState extends ChangeNotifier {
  // From student_info.json (set on splash)
  String? studentName;
  String? studentId;
  String? studentEmail;

  // Screen 1 - Profile
  String fullName = '';
  DateTime? dateOfBirth;
  String gender = 'Male'; // Male / Female / Other
  double? weightKg;
  double? heightCm;

  // Screen 2
  GymPlan? selectedPlan;

  // Screen 3
  String promoCode = '';
  bool get promoGiam50Applied => _promoGiam50Applied;
  bool _promoGiam50Applied = false;
  bool get promoTanThuApplied => _promoTanThuApplied;
  bool _promoTanThuApplied = false;

  void setStudentInfo({String? name, String? id, String? email}) {
    studentName = name;
    studentId = id;
    studentEmail = email;
    notifyListeners();
  }

  void setProfile({
    String? name,
    DateTime? dob,
    String? g,
    double? w,
    double? h,
  }) {
    if (name != null) fullName = name;
    if (dob != null) dateOfBirth = dob;
    if (g != null) gender = g;
    if (w != null) weightKg = w;
    if (h != null) heightCm = h;
    notifyListeners();
  }

  void setPlan(GymPlan? plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  void setPromo(String code) {
    promoCode = code;
    _promoGiam50Applied = false;
    _promoTanThuApplied = false;
    if (code.toUpperCase() == 'GIAM50' && totalBeforePromo > 1500000) {
      _promoGiam50Applied = true;
    }
    if (code.toUpperCase() == 'TANTHU' && (age ?? 999) < 22) {
      _promoTanThuApplied = true;
    }
    notifyListeners();
  }

  /// BMI = weight / (height_m)^2. Null if weight or height missing.
  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm! <= 0) return null;
    final h = heightCm! / 100;
    return weightKg! / (h * h);
  }

  /// Age from dateOfBirth (today - birth).
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int a = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      a--;
    }
    return a;
  }

  /// Plan price (0 if no plan).
  int get totalBeforePromo => selectedPlan?.price ?? 0;

  /// Discount: GIAM50 = 50% off when applicable; TANTHU = 100k off when applicable.
  int get discountAmount {
    int d = 0;
    if (_promoGiam50Applied) d += totalBeforePromo ~/ 2;
    if (_promoTanThuApplied) d += 100000;
    return d;
  }

  int get finalPrice => (totalBeforePromo - discountAmount).clamp(0, totalBeforePromo);

  /// BMI > 30: obesity; Basic should be disabled when obesity.
  bool get isObesity => (bmi ?? 0) > 30;

  bool get canProceedFromPlanSelection {
    if (selectedPlan == null) return false;
    if (isObesity && selectedPlan == GymPlan.basic) return false;
    return true;
  }
}
