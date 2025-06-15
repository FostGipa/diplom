class Moderator {
  final int? idModerator;
  final int idUser;
  final String lastName;
  final String name;
  final String? middleName;

  Moderator({
    this.idModerator,
    required this.idUser,
    required this.lastName,
    required this.name,
    this.middleName,
  });

  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
      idModerator: json['id_moderator'] as int? ?? 0,
      idUser: json['id_user'] as int? ?? 0,
      lastName: json['last_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      middleName: json['middle_name'] as String? ?? '',
    );
  }

  // Метод для конвертации объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id_moderator': idModerator,
      'id_user': idUser,
      'last_name': lastName,
      'name': name,
      'middle_name': middleName,
    };
  }
}
