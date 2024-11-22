
class UserModel {
  final String id;
  String role;
  String firstName;
  String lastName;
  String middleName;
  final String email;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phoneNumber,
  });

  static UserModel empty() => UserModel(id: '', role: '', firstName: '', lastName: '', middleName: '', email: '', phoneNumber: '');

  Map<String, dynamic> toJson() {
    return {
      'Role': role,
      'FirstName': firstName,
      'LastName': lastName,
      'MiddleName': middleName,
      'Email': email,
      'Phone': phoneNumber,
    };
  }
}