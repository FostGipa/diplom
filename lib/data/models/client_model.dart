class Client {
  final int? idClient;
  final int? idUser;
  final String lastName;
  final String name;
  final String? middleName;
  final String gender;
  final String dateOfBirth;
  final String phoneNumber;
  final String? status;
  final String? rating;
  final int? ratingCount;

  Client({
    this.idClient,
    this.idUser,
    required this.lastName,
    required this.name,
    this.middleName,
    required this.gender,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.status,
    this.rating,
    this.ratingCount,
  });


  Map<String, dynamic> toJson() {
    return {
      'id_client': idClient,
      'last_name': lastName,
      'name': name,
      'middle_name': middleName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'phone_number': phoneNumber,
      'client_rating': rating,
      'rating_count': ratingCount,
    };
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idClient: json['id_client'] as int? ?? 0,
      idUser: json['id_user'] as int? ?? 0,
      lastName: json['last_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      middleName: json['middle_name'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rating: json['client_rating'] as String? ?? '',
      ratingCount: json['rating_count'] as int?,
    );
  }
}