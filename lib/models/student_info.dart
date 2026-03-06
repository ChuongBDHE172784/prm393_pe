/// Model for student_info.json (name, student_id, email).
class StudentInfo {
  final String name;
  final String studentId;
  final String email;

  const StudentInfo({
    required this.name,
    required this.studentId,
    required this.email,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
