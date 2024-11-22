class ClientModel {
  String id;
  String firstName;
  String lastName;
  String middleName;
  final String email;
  String phoneNumber;

  ClientModel({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phoneNumber,
  });

  static ClientModel empty() => ClientModel(id: '', firstName: '', lastName: '', middleName: '', email: '', phoneNumber: '');

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FirstName': firstName,
      'LastName': lastName,
      'MiddleName': middleName,
      'Email': email,
      'Phone': phoneNumber,
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['ID'] as String? ?? '',
      firstName: json['FirstName'] as String? ?? '',
      lastName: json['LastName'] as String? ?? '',
      middleName: json['MiddleName'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      phoneNumber: json['Phone'] as String? ?? '',
    );
  }
}