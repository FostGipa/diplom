class Volunteer {
  final int? idVolunteer;
  final int? idUser;
  final String phoneNumber;
  final String lastName;
  final String name;
  final String? middleName;
  final String gender;
  final String dateOfBirth;
  final int? passportSerial;
  final int? passportNumber;
  final int? dobroId;

  Volunteer({
    this.idVolunteer,
    this.idUser,
    required this.phoneNumber,
    required this.lastName,
    required this.name,
    this.middleName,
    required this.gender,
    required this.dateOfBirth,
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
      'date_of_birth': dateOfBirth,
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
      middleName: json['middle_name'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      passportSerial: json['passport_serial'] as int?,
      passportNumber: json['passport_number'] as int?,
      dobroId: json['dobro_id'] as int?,
    );
  }

  @override
  String toString() {
    return 'Volunteer(idVolunteer: $idVolunteer, idUser: $idUser, '
        'phoneNumber: $phoneNumber, lastName: $lastName, name: $name, '
        'middleName: $middleName, gender: $gender, dateOfBirth: $dateOfBirth, '
        'passportSerial: $passportSerial, passportNumber: $passportNumber, '
        'dobroId: $dobroId)';
  }
}
