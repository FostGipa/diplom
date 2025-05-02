import 'package:app/data/models/client_model.dart';
import 'package:app/data/models/volunteer_model.dart';

class TaskModel {
  int? id;
  String? taskNumber;
  String taskName;
  String taskDescription;
  String taskComment;
  List<String> taskCategories;
  String taskDuration;
  Client? client;
  int? clientId;
  List<Volunteer>? volunteers;
  List<int>? volunteersId;
  int taskVolunteersCount;
  String taskStartDate;
  String taskStartTime;
  String? taskEndDate;
  String? taskEndTime;
  String taskAddress;
  String taskCoordinates;
  String taskStatus;

  TaskModel({
    this.id,
    this.taskNumber,
    required this.taskName,
    required this.taskDescription,
    required this.taskComment,
    required this.taskCategories,
    required this.taskDuration,
    this.client,
    this.clientId,
    this.volunteers,
    this.volunteersId,
    required this.taskVolunteersCount,
    required this.taskStartDate,
    required this.taskStartTime,
    this.taskEndDate,
    this.taskEndTime,
    required this.taskAddress,
    required this.taskCoordinates,
    required this.taskStatus,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id_task'] as int? ?? 0,
      taskNumber: json['task_number'],
      taskName: json['task_name'] as String? ?? '',
      taskDuration: json['task_duration'] as String? ?? '',
      taskDescription: json['task_description'] as String? ?? '',
      taskComment: json['task_comment'] as String? ?? '',
      taskCategories: List<String>.from(json['task_categories'] ?? []),
      client: Client.fromJson({
        'id_client': json['id_client'],
        'name': json['client_name'],
        'last_name': json['client_last_name'],
        'middle_name': json['client_middle_name'],
        'date_of_birth': json['client_date_of_birth'],
        'phone_number': json['client_phone']
      }),
      volunteers: (json['volunteers'] as List<dynamic>?)
          ?.map((v) => Volunteer.fromJson(v))
          .toList() ?? [],
      taskVolunteersCount: json['task_volunteers_count'] as int? ?? 0,
      taskStartDate: json['task_start_date'] as String? ?? '',
      taskStartTime: json['task_start_time'] as String? ?? '',
      taskEndDate: json['task_end_date'] as String? ?? '',
      taskEndTime: json['task_end_time'] as String? ?? '',
      taskAddress: json['task_address'] as String? ?? '',
      taskCoordinates: json['task_coordinates'] as String? ?? '',
      taskStatus: json['task_status'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return '''
      TaskModel(
        id: $id,
        taskNumber: $taskNumber,
        taskName: $taskName,
        taskDescription: $taskDescription,
        taskDuration: $taskDuration,
        taskComment: $taskComment,
        taskCategories: $taskCategories,
        client: $client,
        volunteers: $volunteers,
        taskVolunteersCount: $taskVolunteersCount,
        taskStartDate: $taskStartDate,
        taskStartTime: $taskStartTime,
        taskEndDate: $taskEndDate,
        taskEndTime: $taskEndTime,
        taskAddress: $taskAddress,
        taskCoordinates: $taskCoordinates,
        taskStatus: $taskStatus
      )
      ''';
  }

  Map<String, dynamic> toJson() {
    return {
      'id_task': id,
      'task_number': taskNumber,
      'task_name': taskName,
      'task_description': taskDescription,
      'task_duration': taskDuration,
      'task_comment': taskComment,
      'task_categories': taskCategories,
      'id_client': clientId,
      'id_volunteers': volunteersId,
      'task_volunteers_count': taskVolunteersCount,
      'task_start_date': taskStartDate,
      'task_start_time': taskStartTime,
      'task_end_date': taskEndDate,
      'task_end_time': taskEndTime,
      'task_address': taskAddress,
      'task_coordinates': taskCoordinates,
      'task_status': taskStatus,
    };
  }
}