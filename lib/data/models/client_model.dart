class Client {
  final int? idClient;
  final int? idUser;
  final String lastName;
  final String name;
  final String? middleName;
  final String gender;
  final String phoneNumber;

  Client({
    this.idClient,
    this.idUser,
    required this.lastName,
    required this.name,
    this.middleName,
    required this.gender,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_client': idClient,
      'last_name': lastName,
      'name': name,
      'middle_name': middleName,
      'gender': gender,
      'phone_number': phoneNumber,
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
      phoneNumber: json['phone_number'] as String? ?? '',
    );
  }
}