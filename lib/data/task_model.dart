import 'package:app/data/models/client_model.dart';
import 'package:app/data/models/volunteer_model.dart';

class TaskModel {
  int id;
  String taskName;
  String taskDescription;
  String taskComment;
  List<String> taskCategories;
  Client client;
  List<Volunteer> volunteers;
  int taskVolunteersCount;
  String taskStartDate;
  String taskStartTime;
  String taskEndDate;
  String taskAddress;
  String taskCoordinates;
  String taskStatus;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.taskComment,
    required this.taskCategories,
    required this.client,
    required this.volunteers,
    required this.taskVolunteersCount,
    required this.taskStartDate,
    required this.taskStartTime,
    required this.taskEndDate,
    required this.taskAddress,
    required this.taskCoordinates,
    required this.taskStatus,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id_task'] as int? ?? 0,
      taskName: json['task_name'] as String? ?? '',
      taskDescription: json['task_description'] as String? ?? '',
      taskComment: json['task_comment'] as String? ?? '',
      taskCategories: List<String>.from(json['task_categories'] ?? []),
      client: Client.fromJson({
        'id_client': json['id_client'],
        'name': json['client_name'],
        'last_name': json['client_last_name'],
        'middle_name': json['client_middle_name'],
        'phone_number': json['client_phone']
      }),
      volunteers: (json['volunteers'] as List<dynamic>?)
          ?.map((v) => Volunteer.fromJson(v))
          .toList() ?? [],
      taskVolunteersCount: json['task_volunteers_count'] as int? ?? 0,
      taskStartDate: json['task_start_date'] as String? ?? '',
      taskStartTime: json['task_start_time'] as String? ?? '',
      taskEndDate: json['task_end_date'] as String? ?? '',
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
        taskName: $taskName,
        taskDescription: $taskDescription,
        taskComment: $taskComment,
        taskCategories: $taskCategories,
        client: $client,
        volunteers: $volunteers,
        taskVolunteersCount: $taskVolunteersCount,
        taskStartDate: $taskStartDate,
        taskStartTime: $taskStartTime,
        taskEndDate: $taskEndDate,
        taskAddress: $taskAddress,
        taskCoordinates: $taskCoordinates,
        taskStatus: $taskStatus
      )
      ''';
  }


  // Map<String, dynamic> toJson() {
  //   return {
  //     'id_task': id,
  //     'task_name': taskName,
  //     'task_description': taskDescription,
  //     'task_comment': taskComment,
  //     'task_categories': taskCategories,
  //     'id_client': taskClientId,
  //     'id_volunteers': taskVolunteerIds,
  //     'task_volunteers_count': taskVolunteersCount,
  //     'task_start_date': taskStartDate,
  //     'task_start_time': taskStartTime,
  //     'task_end_date': taskEndDate,
  //     'task_address': taskAddress,
  //     'task_coordinates': taskCoordinates,
  //     'task_status': taskStatus
  //   };
  // }
}