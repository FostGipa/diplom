import 'package:app/features/common/screens/chat.dart';
import 'package:app/features/moderator/screens/moderator_volunteer_profile.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../data/models/client_model.dart';
import '../controllers/moderator_users_controller.dart';

class ModeratorUsersScreen extends StatefulWidget {
  const ModeratorUsersScreen({super.key});

  @override
  State<ModeratorUsersScreen> createState() => _ModeratorUsersScreenState();
}

class _ModeratorUsersScreenState extends State<ModeratorUsersScreen> {
  final ModeratorUsersController _controller = Get.put(ModeratorUsersController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Пользователи",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final query = _controller.searchQuery.value.toLowerCase();

        final filteredClients = _controller.clients.where((client) {
          final fullName = '${client.lastName} ${client.name}'.toLowerCase();
          return fullName.contains(query) || client.phoneNumber.contains(query);
        }).toList();

        final filteredVolunteers = _controller.volunteers.where((volunteer) {
          final fullName = '${volunteer.lastName} ${volunteer.name}'.toLowerCase();
          return fullName.contains(query) || volunteer.phoneNumber.contains(query);
        }).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: TSizes.spaceBtwSections),
              _buildUserSection("Клиенты", filteredClients),
              SizedBox(height: TSizes.spaceBtwSections),
              _buildUserSection("Волонтёры", filteredVolunteers),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      backgroundColor: WidgetStateProperty.all(Colors.grey.shade300),
      controller: _controller.searchController,
      hintText: 'Поиск пользователя...',
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
      leading: const Icon(Icons.search),
      onChanged: (value) => _controller.searchQuery.value = value,
      trailing: [
        if (_controller.searchQuery.value.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.searchController.clear();
              _controller.searchQuery.value = '';
              _controller.searchFocusNode.unfocus();
            },
          ),
      ],
    );
  }

  Widget _buildUserSection(String title, List<dynamic> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        SizedBox(height: TSizes.spaceBtwItems),
        Obx(() {
          return Column(
            children: users.map((user) => UserCard(
              user: user,
              controller: _controller,
              isExpanded: _controller.expandedUserId.value == user.idUser,
              onExpand: () {
                _controller.expandedUserId.value =
                _controller.expandedUserId.value == user.idUser ? null : user.idUser;
              },
            )).toList(),
          );
        }),
      ],
    );
  }
}

class UserCard extends StatefulWidget {
  final dynamic user;
  final ModeratorUsersController controller;
  final bool isExpanded;
  final VoidCallback onExpand;
  const UserCard({super.key, this.user, required this.controller, required this.isExpanded, required this.onExpand});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    final isBlocked = widget.user.status == 'Заблокирован';
    final statusText = isBlocked ? 'Заблокирован' : 'Активный';
    final statusColor = isBlocked ? Colors.red : Colors.green;
    return Column(
      children: [
        InkWell(
          onTap: widget.onExpand,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.user.lastName} ${widget.user.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(widget.user is Client ? 'Клиент' : 'Волонтёр'),
                      Text(widget.user.phoneNumber, style: const TextStyle(color: Colors.grey)),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(statusText,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                Icon(widget.isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (widget.isExpanded) _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildActionButton(Iconsax.message, 'Чат', () {
              Get.to(ChatScreen(isSupportChat: true, userId: widget.user.idUser));
            }),
            _buildActionButton(Iconsax.user, 'Профиль', () => Get.to(() => ModeratorVolunteerProfile(userId: widget.user.idUser))),
            _buildActionButton(
                widget.user.status == 'Активный' ? Iconsax.close_circle : Iconsax.tick_circle,
                widget.user.status == 'Активный' ? 'Блок.' : 'Разблок.',
                    () async {
                  if (widget.user.status == 'Активный') {
                    await widget.controller.blockUser(widget.user.idUser);
                    setState(() {});  
                  } else {
                    await widget.controller.unblockUser(widget.user.idUser);
                    setState(() {});
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String text, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            SizedBox(height: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
