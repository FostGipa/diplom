class Volunteer {
  final int? idVolunteer;
  final int? idUser;
  final String phoneNumber;
  final String lastName;
  final String name;
  final String? middleName;
  final String gender;
  final String passportSerial;
  final String passportNumber;
  final String? dobroId;

  Volunteer({
    this.idVolunteer,
    this.idUser,
    required this.phoneNumber,
    required this.lastName,
    required this.name,
    this.middleName,
    required this.gender,
    required this.passportSerial,
    required this.passportNumber,
    this.dobroId,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'last_name': lastName,
      'name': name,
      'middle_name': middleName,
      'gender': gender,
      'passport_serial': passportSerial,
      'passport_number': passportNumber,
      'dobro_id': dobroId,
    };
  }

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      idVolunteer: json['id_volunteer'] as int? ?? 0,
      idUser: json['id_user'] as int? ?? 0,
      phoneNumber: json['phone_number'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      passportSerial: json['passportSerial'] as String? ?? '',
      passportNumber: json['passportNumber'] as String? ?? '',
      dobroId: json['DobroID'] as String? ?? '',
    );
  }
}
