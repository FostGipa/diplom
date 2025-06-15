import 'package:app/features/common/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/moderator_tickets_controller.dart';

class ModeratorTicketsScreen extends StatefulWidget {
  const ModeratorTicketsScreen({super.key});

  @override
  State<ModeratorTicketsScreen> createState() => _ModeratorTicketsScreenState();
}

class _ModeratorTicketsScreenState extends State<ModeratorTicketsScreen> {
  final ModeratorTicketsController _controller = Get.put(ModeratorTicketsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Поддержка",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.tickets.isEmpty) {
          return const Center(child: Text('Нет активных тикетов'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _controller.tickets.length,
          itemBuilder: (context, index) {
            final userId = _controller.tickets[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: const Icon(Icons.person, size: 32),
                title: Text('Пользователь ID: $userId', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(ChatScreen(isSupportChat: true, userId: userId));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
