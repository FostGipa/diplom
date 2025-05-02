import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import '../../../data/models/message_model.dart';
import '../../../server/service.dart';

class ChatController extends GetxController {
  final ServerService serverService = ServerService();

  var messages = <Message>[].obs;
  var isLoading = true.obs;
  IOWebSocketChannel? channel;

  Future<void> sendMessage(int taskId, int userId, String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      await serverService.sendMessage(
        taskId: taskId,
        senderId: userId,
        messageText: messageText.trim(),
      );
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
}
