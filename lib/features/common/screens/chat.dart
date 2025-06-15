import 'package:app/features/common/controllers/chat_controller.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/sizes.dart';

class ChatScreen extends StatefulWidget {
  final int? taskId;
  final int? userId;
  final bool isSupportChat;

  const ChatScreen({
    super.key,
    this.taskId,
    this.userId,
    this.isSupportChat = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _controller = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.getUser();
    if (widget.isSupportChat) {
      _controller.loadSupportMessages(widget.userId!);
      _controller.initSupportWebSocket(_controller.userData.value!.idUser!);
    } else if (widget.taskId != null) {
      _controller.loadMessages(widget.taskId!);
      _controller.initWebSocket(widget.userId!, widget.taskId!);
    }

  }

  @override
  void dispose() {
    _scrollController.dispose();  // Освобождаем ресурсы
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      if (widget.isSupportChat) {
        _controller.sendSupportMessage(_controller.userData.value!.idUser!, _messageController.text);
      } else {
        _controller.sendMessage(
            widget.taskId!, widget.userId!, _messageController.text);
      }
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Iconsax.arrow_left_2),
        ),
        title: Text(
          widget.isSupportChat ? 'Поддержка' : 'Чат',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          // Пока идет загрузка, показываем CircularProgressIndicator
          return Center(child: CircularProgressIndicator());
        }

        // После завершения загрузки отображаем чат
        return Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages = _controller.messages;

                if (messages.isEmpty) {
                  return const Center(child: Text('Нет сообщений'));
                }

                // Прокрутка в самый низ, когда загружаются сообщения
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,  // Подключаем ScrollController
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _controller.userData.value!.idUser;

                    return ChatBubble(
                      message: message.messageText,
                      isCurrentUser: isMe,
                      timestamp: message.createdAt,
                      senderName: message.senderName,
                      senderRole: message.senderRole,
                      isSupportChat: widget.isSupportChat,
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 56, // Высота кнопки, такая же как у TextField
                    width: 56,  // Ширина кнопки
                    decoration: BoxDecoration(
                      color: TColors.green, // Цвет фона кнопки
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Iconsax.direct_right),
                      onPressed: _sendMessage,
                      color: Colors.white, // Цвет иконки
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String timestamp;
  final String senderName;
  final String senderRole;
  final bool isSupportChat;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
    required this.senderName,
    required this.senderRole,
    required this.isSupportChat,
  });

  @override
  Widget build(BuildContext context) {
    // Форматируем время
    final formattedTime = DateFormat('HH:mm').format(DateTime.parse(timestamp));

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5), // Ограничение по ширине
        decoration: BoxDecoration(
          color: isCurrentUser ? TColors.green.withValues(alpha: 0.5) : Colors.grey.shade500.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$senderRole ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // не забудь указать цвет
                    ),
                  ),
                  TextSpan(
                    text: isSupportChat ? '' : senderName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: TColors.black,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 5),
            // Время
            Text(
              formattedTime,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}