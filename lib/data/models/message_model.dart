class Message {
  int? id;
  int? taskId;
  int senderId;
  String senderName;
  String senderRole;
  String messageText;
  String createdAt;

  Message({
    this.id,
    this.taskId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.messageText,
    required this.createdAt,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id_message'] as int? ?? 0,
      taskId: json['id_task'] as int? ?? 0,
      senderId: json['sender_id'],
      senderName: json['sender_name'] as String? ?? '',
      senderRole: json['sender_role'] as String? ?? '',
      messageText: json['message_text'],
      createdAt: json['created_at'],
    );
  }

  // Метод для преобразования объекта в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'id_message': id,
      'id_task': taskId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'message_text': messageText,
      'created_at': createdAt,
    };
  }
}
