import 'package:app/data/user/client_model.dart';
import 'package:app/data/user/volunteer_model.dart';

class TaskModel {
  String id;
  String taskName;
  String taskDescription;
  String taskComment;
  List<String> taskCategories;
  String taskClientId; // Идентификатор клиента
  List<String> taskVolunteerIds;
  int taskVolunteersCount;
  String taskStartDate;
  String taskStartTime;
  String taskEndDate;
  String taskAddress;
  String taskCoordinates;
  String taskStatus;
  ClientModel taskClient; // Объект клиента
  List<VolunteerModel> taskVolunteers; // Список волонтеров

  TaskModel({
    this.id = '', // По умолчанию пустая строка
    required this.taskName,
    required this.taskDescription,
    required this.taskComment,
    required this.taskCategories,
    required this.taskClientId,
    required this.taskVolunteerIds,
    required this.taskVolunteersCount,
    required this.taskStartDate,
    required this.taskStartTime,
    required this.taskEndDate,
    required this.taskAddress,
    required this.taskCoordinates,
    required this.taskStatus,
    required this.taskClient,
    required this.taskVolunteers,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      taskName: json['taskName'] as String? ?? '',
      taskDescription: json['taskDescription'] as String? ?? '',
      taskComment: json['taskComment'] as String? ?? '',
      taskCategories: List<String>.from(json['taskCategories'] as List? ?? []),
      taskClientId: json['taskClientId'] as String? ?? '',
      taskVolunteerIds: List<String>.from(json['taskVolunteerIds'] as List? ?? []),
      taskVolunteersCount: json['taskVolunteersCount'] as int,
      taskStartDate: json['taskStartDate'] as String? ?? '',
      taskStartTime: json['taskStartTime'] as String,
      taskEndDate: json['taskEndDate'] as String? ?? '',
      taskAddress: json['taskAddress'] as String? ?? '',
      taskCoordinates: json['taskCoordinates'] as String? ?? '',
      taskStatus: json['taskStatus'] as String,
      taskClient: ClientModel.empty(),
      taskVolunteers: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskComment': taskComment,
      'taskCategories': taskCategories,
      'taskClientId': taskClientId, // Убедитесь, что это строка
      'taskVolunteerIds': taskVolunteerIds,
      'taskVolunteersCount': taskVolunteersCount,
      'taskStartDate': taskStartDate,
      'taskStartTime': taskStartTime,
      'taskEndDate': taskEndDate,
      'taskAddress': taskAddress,
      'taskCoordinates': taskCoordinates,
      'taskStatus': taskStatus
    };
  }

  static TaskModel empty() => TaskModel(
    id: '',
    taskName: '',
    taskDescription: '',
    taskComment: '',
    taskCategories: [],
    taskClientId: '',
    taskVolunteerIds: [],
    taskVolunteersCount: 0,
    taskStartDate: '',
    taskStartTime: '',
    taskEndDate: '',
    taskAddress: '',
    taskCoordinates: '',
    taskStatus: '',
    taskClient: ClientModel.empty(),
    taskVolunteers: [],
  );
}