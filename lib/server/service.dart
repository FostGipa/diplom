import 'dart:convert';
import 'package:app/data/models/client_model.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:http/http.dart' as http;
import '../data/models/user_model.dart';
import '../data/models/volunteer_model.dart';
import 'package:get_storage/get_storage.dart';

import '../data/task_model.dart';

class ServerService {
  static const String baseUrl = "http://10.0.2.2:3000";

  Future<String?> sendOtp(String phoneNumber) async {
    final url = Uri.parse("$baseUrl/send-otp");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data["otp"]);
        return data["otp"].toString();
      } else {
        print("Ошибка: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return null;
    }
  }

  Future<List<String>?> fetchAddressSuggestions(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse("$baseUrl/suggest/address");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestions = (data['suggestions'] as List)
            .map((suggestion) => suggestion['value'] as String)
            .toList();
        return suggestions;
      } else {
        print("Ошибка: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return null;
    }
  }

  Future<List<String>?> fetchFioSuggestions(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse("$baseUrl/suggest/fio");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestions = (data['suggestions'] as List)
            .map((suggestion) => suggestion['value'] as String)
            .toList();
        return suggestions;
      } else {
        print("Ошибка: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return null;
    }
  }

  Future<void> addVolunteer(Volunteer volunteer) async {
    final url = Uri.parse('$baseUrl/bd/new-volunteer');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(volunteer.toJson()),
    );

    if (response.statusCode == 200) {
      TLoaders.successSnackBar(title: 'Успешно', message: 'Волонтер успешно добавлен');
    } else {
      print('Ошибка при добавлении волонтера: ${response.body}');
    }
  }

  Future<void> addClient(Client client) async {
    final url = Uri.parse('$baseUrl/bd/new-client');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      TLoaders.successSnackBar(title: 'Успешно', message: 'Клиент успешно добавлен');
    } else {
      print('Ошибка при добавлении клиента: ${response.body}');
    }
  }

  Future<User?> getUser(String phoneNumber) async {
    final encodedPhone = Uri.encodeComponent(phoneNumber); // Кодируем номер
    final Uri url = Uri.parse("$baseUrl/get-user?phone=$encodedPhone"); // Подставляем в URL
    final box = GetStorage(); // Инициализируем GetStorage

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));

        // Сохраняем пользователя в кеш
        box.write("cached_user_$phoneNumber", jsonEncode(user.toJson()));

        return user;
      } else if (response.statusCode == 404) {
        final data = jsonDecode(response.body);
        TLoaders.errorSnackBar(title: 'Ошибка', message: data["message"]);
      }
    } catch (e) {
      print("Ошибка при получении данных пользователя: $e");
    }
  }


  Future<Client?> getClient(int userId) async {
    final Uri url = Uri.parse("$baseUrl/get-client?id_user=$userId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
    return null;
  }

  Future<Volunteer?> getVolunteer(int userId) async {
    final Uri url = Uri.parse("$baseUrl/get-volunteer?id_user=$userId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Volunteer.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Ошибка при получении данных волонтера: $e");
    }
    return null;
  }

  Future<List<TaskModel>> getClientTasks(int clientId) async {
    final Uri url = Uri.parse("$baseUrl/get-client-tasks?id_client=$clientId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print("Клиент не найден");
        return [];
      } else {
        print("Ошибка сервера: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Ошибка при получении задач клиента: $e");
      return [];
    }
  }

  Future<TaskModel?> getTaskById(int taskId) async {
    final Uri url = Uri.parse("$baseUrl/get-task?taskId=$taskId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TaskModel.fromJson(data);
      } else {
        print("Ошибка сервера: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Ошибка при получении задачи: $e");
      return null;
    }
  }
}