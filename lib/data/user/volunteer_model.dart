class VolunteerModel {
  String id;
  String firstName;
  String lastName;
  String middleName;
  final String email;
  String phoneNumber;
  String passport;
  String dobroId;

  VolunteerModel({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phoneNumber,
    required this.passport,
    required this.dobroId,
  });

  static VolunteerModel empty() => VolunteerModel(id: '', firstName: '', lastName: '', middleName: '', email: '', phoneNumber: '', passport: '', dobroId: '');

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FirstName': firstName,
      'LastName': lastName,
      'MiddleName': middleName,
      'Email': email,
      'Phone': phoneNumber,
      'Passport': passport,
      'DobroID': dobroId,
    };
  }

  factory VolunteerModel.fromJson(Map<String, dynamic> json) {
    return VolunteerModel(
      id: json['ID'] as String? ?? '',
      firstName: json['FirstName'] as String? ?? '',
      lastName: json['LastName'] as String? ?? '',
      middleName: json['MiddleName'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      phoneNumber: json['Phone'] as String? ?? '',
      passport: json['Passport'] as String? ?? '',
      dobroId: json['DobroID'] as String? ?? '',
    );
  }
}