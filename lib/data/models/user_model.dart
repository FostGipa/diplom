class User {
  final int? idUser;
  final String phoneNumber;
  final String role;
  final String createdAt;

  User({
    this.idUser,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'] as int? ?? 0,
      phoneNumber: json['phone_number'] as String? ?? '',
      role: json['role'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  // Метод для конвертации объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'phone_number': phoneNumber,
      'role': role,
      'created_at': createdAt,
    };
  }
}
