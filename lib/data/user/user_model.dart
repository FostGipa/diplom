
class UserModel {
  final String id;
  String role;

  UserModel({
    required this.id,
    required this.role,
  });

  static UserModel empty() => UserModel(id: '', role: '');

  Map<String, dynamic> toJson() {
    return {
      'Role': role,
    };
  }
}