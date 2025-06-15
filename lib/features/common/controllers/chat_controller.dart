import 'dart:convert';
import 'package:app/utils/loaders/loaders.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../server/service.dart';
import '../../../utils/validators/xss_checker.dart';

class ChatController extends GetxController {
  final ServerService serverService = ServerService();

  var messages = <Message>[].obs;
  var isLoading = true.obs;
  IOWebSocketChannel? channel;
  Rx<User?> userData = Rx<User?>(null);

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> sendMessage(int taskId, int userId, String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      final sanitized = sanitizeMessage(messageText.trim());

      if (sanitized == null) {
        TLoaders.errorSnackBar(title: 'Ошибка', message: 'Сообщение содержит запрещённые теги');
      } else {
        await serverService.sendMessage(
          taskId: taskId,
          senderId: userId,
          messageText: sanitized,
        );
      }
    } catch (e) {
      print('❌ Ошибка при отправке сообщения: $e');
    }
  }

  Future<void> loadMessages(int taskId) async {
    try {
      isLoading.value = true;
      final fetchedMessages = await serverService.getMessagesForTask(taskId);
      List<Message> messagesWithSenderNames = [];

      for (var message in fetchedMessages) {
        var sender;
        String senderRole = 'Неизвестный';

        sender = await serverService.getClient(message.senderId);
        if (sender != null) {
          senderRole = 'Клиент';
        } else {
          sender = await serverService.getVolunteer(message.senderId);
          if (sender != null) {
            senderRole = 'Волонтер';
          }
        }

        message.senderName = sender?.name ?? 'Неизвестный';
        message.senderRole = senderRole;

        messagesWithSenderNames.add(message);
      }

      messages.value = messagesWithSenderNames;
    } catch (e) {
      print('❌ Ошибка загрузки сообщений в контроллере: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void initWebSocket(int idUser, int taskId) {
    channel = IOWebSocketChannel.connect('ws://80.78.243.244:3000?userId=$idUser');
    _listenWebSocket(taskId);
  }

  void _listenWebSocket(int taskId) {
    channel?.stream.listen((message) async {
      try {
        final Map<String, dynamic> data = jsonDecode(message);

        if (data['event'] == 'new_message' && data['taskId'] == taskId) {
          var sender;
          String senderRole = 'Неизвестный';

          sender = await serverService.getClient(data['senderId']);
          if (sender != null) {
            senderRole = 'Клиент';
          } else {
            sender = await serverService.getVolunteer(data['senderId']);
            if (sender != null) {
              senderRole = 'Волонтер';
            }
          }

          final newMessage = Message(
            senderId: data['senderId'],
            messageText: data['messageText'],
            createdAt: data['createdAt'],
            senderName: sender?.name ?? 'Неизвестный',
            senderRole: senderRole,
          );

          messages.add(newMessage);
        }
      } catch (e) {
        print("❌ Ошибка парсинга WebSocket-сообщения: $e");
      }
    });
  }

  Future<void> sendSupportMessage(int userId, String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      final sanitized = sanitizeMessage(messageText.trim());

      if (sanitized == null) {
        TLoaders.errorSnackBar(title: 'Ошибка', message: 'Сообщение содержит запрещённые теги');
      } else {
        await serverService.sendSupportMessage(
          senderId: userId,
          messageText: sanitized,
        );
      }
    } catch (e) {
      print('❌ Ошибка при отправке сообщения в поддержку: $e');
    }
  }

  Future<void> loadSupportMessages(int userId) async {
    try {
      isLoading.value = true;
      final fetchedMessages = await serverService.getSupportMessages(userId);
      List<Message> messagesWithSenderNames = [];

      for (var message in fetchedMessages) {
        var sender;
        String senderRole = 'Неизвестный';

        if (message.senderId == userId) {
          sender = await serverService.getClient(userId);
          senderRole = 'Клиент';
        } else {
          senderRole = 'Поддержка';
        }

        message.senderName = sender?.name ?? 'Неизвестный';
        message.senderRole = senderRole;
        messagesWithSenderNames.add(message);
      }

      messages.value = messagesWithSenderNames;
    } catch (e) {
      print('❌ Ошибка загрузки сообщений поддержки: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void initSupportWebSocket(int userId) {
    channel = IOWebSocketChannel.connect('ws://80.78.243.244:3000?userId=$userId');
    _listenSupportWebSocket(userId);
  }

  void _listenSupportWebSocket(int userId) {
    channel?.stream.listen((message) async {
      try {
        final Map<String, dynamic> data = jsonDecode(message);

        if (data['event'] == 'support_message' && (data['senderId'] == userId || data['receiverId'] == userId)) {
          var sender;
          String senderRole = 'Неизвестный';

          if (data['senderId'] == userId) {
            senderRole = 'Поддержка';
          } else {
            sender = await serverService.getClient(data['senderId']);
            senderRole = 'Клиент';
          }

          final newMessage = Message(
            senderId: data['senderId'],
            messageText: data['messageText'],
            createdAt: data['createdAt'],
            senderName: sender?.name ?? 'Неизвестный',
            senderRole: senderRole,
          );

          messages.add(newMessage);
        }
      } catch (e) {
        print("❌ Ошибка WebSocket поддержки: $e");
      }
    });
  }
}
