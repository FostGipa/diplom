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
  final int? helpHours;
  final int? completedTasks;
  final String? rating;
  final int? ratingCount;

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
    this.helpHours,
    this.completedTasks,
    this.rating,
    this.ratingCount
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
      'help_hours': helpHours,
      'completed_tasks': completedTasks,
      'rating': rating,
      'rating_count': ratingCount,
    };
  }

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      idVolunteer: json['id_volunteer'] as int? ?? 0,
      idUser: json['id_user'] as int? ?? 0,
      phoneNumber: json['phone_number'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      middleName: json['middle_name'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      passportSerial: json['passport_serial'] as int?,
      passportNumber: json['passport_number'] as int?,
      dobroId: json['dobro_id'] as int?,
      helpHours: json['help_hours'] as int?,
      completedTasks: json['completed_tasks'] as int?,
      rating: json['rating'] as String? ?? '',
      ratingCount: json['rating_count'] as int?,
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
