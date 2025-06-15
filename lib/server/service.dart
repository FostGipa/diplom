import 'dart:convert';
import 'package:app/data/models/client_model.dart';
import 'package:app/features/authentication/screens/signup.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../client_navigation_menu.dart';
import '../data/models/message_model.dart';
import '../data/models/user_model.dart';
import '../data/models/volunteer_model.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/task_model.dart';
import '../volunteer_navigation_menu.dart';

class ServerService {

  static const String baseUrl = "http://80.78.243.244:3000";

  // Отправка OTP кода
  Future<String?> sendOtp(String phoneNumber) async {
    final url = Uri.parse("$baseUrl/service/send-otp");
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

    final url = Uri.parse("$baseUrl/service/suggest/address");
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

    final url = Uri.parse("$baseUrl/service/suggest/fio");
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
      getUser(volunteer.phoneNumber);
      Get.offAll(VolunteerNavigationMenu());
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
      getUser(client.phoneNumber);
      Get.offAll(ClientNavigationMenu());
      TLoaders.successSnackBar(title: 'Успешно', message: 'Клиент успешно добавлен');
    } else {
      print('Ошибка при добавлении клиента: ${response.body}');
    }
  }

  Future<User?> getUser(String phoneNumber) async {
    final encodedPhone = Uri.encodeComponent(phoneNumber); // Кодируем номер
    final Uri url = Uri.parse("$baseUrl/bd/get-user?phone=$encodedPhone"); // Подставляем в URL
    final box = GetStorage(); // Инициализируем GetStorage

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));

        // Сохраняем пользователя в кеш
        box.write("cached_user", jsonEncode(user.toJson()));
        await OneSignal.login(user.idUser.toString());

        return user;
      } else if (response.statusCode == 404) {
        Get.offAll(SignupScreen(phoneNumber: phoneNumber));
      }
    } catch (e) {
      print("Ошибка при получении данных пользователя: $e");
    }
    return null;
  }

  User? getCachedUser() {
    final box = GetStorage();
    final cachedData = box.read("cached_user");

    if (cachedData != null) {
      return User.fromJson(jsonDecode(cachedData)); // Декодируем JSON обратно в объект User
    }
    return null; // Если данных нет, возвращаем null
  }

  Future<bool> createTask(TaskModel task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bd/new-task'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        print("Задача успешно добавлена: ${response.body}");
        return true;
      } else {
        print("Ошибка при добавлении задачи: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return false;
    }
  }

  Future<Client?> getClient(int userId) async {
    final Uri url = Uri.parse("$baseUrl/bd/get-client?id_user=$userId");
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
    final Uri url = Uri.parse("$baseUrl/bd/get-volunteer?id_user=$userId");
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
    final Uri url = Uri.parse("$baseUrl/bd/get-client-tasks?id_client=$clientId");
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

  Future<List<TaskModel>> getVolunteerTasks(int volunteerId) async {
    final Uri url = Uri.parse("$baseUrl/bd/get-volunteer-tasks?id_volunteer=$volunteerId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print("Волонтер не найден");
        return [];
      } else {
        print("Ошибка сервера: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Ошибка при получении задач волонтера: $e");
      return [];
    }
  }

  Future<List<TaskModel>> getAllTasks() async {
    final Uri url = Uri.parse("$baseUrl/bd/get-all-tasks");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        print("Ошибка сервера: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Ошибка при получении задач: $e");
      return [];
    }
  }

  Future<TaskModel?> getTaskById(int taskId) async {
    final Uri url = Uri.parse("$baseUrl/bd/get-task?taskId=$taskId");

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

  Future<Map<String, dynamic>?> getAddressCoordinates(String query) async {

    final Uri url = Uri.parse("$baseUrl/service/suggest/address_coordinates");

    if (query.isEmpty) {
      throw ArgumentError("Не указан адрес");
    }

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception("Ошибка сервера: ${response.statusCode}");
    }
  }

  Future<bool> acceptRequest(int idTask, int idVolunteer) async {
    final url = Uri.parse("$baseUrl/bd/accept-request");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_task": idTask,
          "id_volunteers": idVolunteer
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Ошибка: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return false;
    }
  }

  Future<bool> endTask(String idTask) async {
    final url = Uri.parse("$baseUrl/bd/complete-task");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"taskId": idTask}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Ошибка: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Ошибка запроса: $e");
      return false;
    }
  }

  Future<void> updateVolunteerRating(int taskId, double userRating) async {
    final url = Uri.parse("$baseUrl/bd/update-rating");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_task': taskId,
          'new_rating': userRating,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Рейтинг успешно обновлён: $responseData');
        // Можешь показать уведомление пользователю или обновить локальные данные
      } else {
        print('Ошибка при обновлении рейтинга: ${response.body}');
      }
    } catch (e) {
      print('Ошибка сети: $e');
    }
  }

  Future<void> updateClientRating(int taskId, double userRating) async {
    final url = Uri.parse("$baseUrl/bd/update-client-rating");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_task': taskId,
          'new_rating': userRating,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Рейтинг успешно обновлён: $responseData');
      } else {
        print('Ошибка при обновлении рейтинга: ${response.body}');
      }
    } catch (e) {
      print('Ошибка сети: $e');
    }
  }

  Future<void> cancelTask(int taskId) async {
    final url = Uri.parse("$baseUrl/bd/cancel-task");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'taskId': taskId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Успех: ${data['message']}');
      } else {
        final error = jsonDecode(response.body);
        print('❌ Ошибка: ${error['message']}');
        throw Exception('Ошибка при отмене заявки: ${error['message']}');
      }
    } catch (e) {
      print('❌ Ошибка запроса: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage({required int taskId, required int senderId, required String messageText}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bd/send-message'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'taskId': taskId,
        'senderId': senderId,
        'messageText': messageText,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Возвращаем id_message и created_at
    } else {
      throw Exception('Ошибка отправки сообщения');
    }
  }

  Future<List<Message>> getMessagesForTask(int taskId) async {
    final url = Uri.parse('$baseUrl/bd/get-chat-messages?taskId=$taskId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Message>((item) => Message.fromJson(item)).toList();
      } else {
        throw Exception('Ошибка получения сообщений: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Ошибка при получении сообщений: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendSupportMessage({required int senderId, required String messageText}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bd/send-support-message'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'senderId': senderId,
        'messageText': messageText,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка отправки сообщения');
    }
  }

  Future<List<Message>> getSupportMessages(int userId) async {
    final url = Uri.parse('$baseUrl/bd/get-support-messages?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Message>((item) => Message.fromJson(item)).toList();
      } else {
        throw Exception('Ошибка получения сообщений: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Ошибка при получении сообщений: $e');
      rethrow;
    }
  }

  Future<bool> updateTask({
    required int id,
    required String taskName,
    required String taskDescription,
    required String taskComment,
    required int taskVolunteersCount,
    required String taskStartDate,
    required String taskStartTime,
    required String taskAddress,
    required String taskDuration,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/bd/edit-task');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'taskId': id,
          'taskName': taskName,
          'taskDescription': taskDescription,
          'taskComment': taskComment,
          'taskVolunteersCount': taskVolunteersCount,
          'taskStartDate': taskStartDate,
          'taskStartTime': taskStartTime,
          'taskAddress': taskAddress,
          'taskDuration': taskDuration,
        }),
      );

      if (response.statusCode == 200) {
        print('Задача успешно обновлена');
        return true;
      } else {
        print('Ошибка при обновлении задачи: ${response.statusCode} — ${response.body}');
        return false;
      }
    } catch (e) {
      print('Ошибка при соединении с сервером: $e');
      return false;
    }
  }

  Future<List<Client>> getAllClients() async {
    final Uri url = Uri.parse('$baseUrl/bd/get-all-clients');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Client.fromJson(json)).toList();
      } else {
        print("Ошибка при получении клиентов: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Ошибка при подключении к серверу: $e");
      return [];
    }
  }

  Future<List<Volunteer>> getAllVolunteers() async {
    final Uri url = Uri.parse('$baseUrl/bd/get-all-volunteers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Volunteer.fromJson(json)).toList();
      } else {
        print("Ошибка при получении волонтёров: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Ошибка при подключении к серверу: $e");
      return [];
    }
  }

  Future<void> blockUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bd/block-user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_user': userId
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Не удалось заблокировать пользователя');
      }
    } catch (e) {
      throw Exception('Ошибка при блокировке пользователя: $e');
    }
  }

  // Метод для разблокировки пользователя
  Future<void> unblockUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bd/unblock-user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_user': userId
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Не удалось разблокировать пользователя');
      }
    } catch (e) {
      throw Exception('Ошибка при разблокировке пользователя: $e');
    }
  }

  Future<List<int>> getSupportTickets() async {
    final url = Uri.parse('$baseUrl/bd/get-support-tickets');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<int>((item) => item['user_id'] as int).toList();
      } else {
        throw Exception('Ошибка получения тикетов: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Ошибка при получении тикетов: $e');
      rethrow;
    }
  }

  Future<bool> cancelVolunteerParticipation(int taskId, int volunteerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bd/cancel-task-volunteer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'taskId': taskId,
        'volunteerId': volunteerId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Ошибка отмены участия волонтера: ${response.body}');
      return false;
    }
  }
}