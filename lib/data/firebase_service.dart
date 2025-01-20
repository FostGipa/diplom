import 'package:app/data/task_model.dart';
import 'package:app/data/user/client_model.dart';
import 'package:app/data/user/volunteer_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение клиента по ID
  Future<ClientModel> getClientById(String clientId) async {
    if (clientId.isEmpty) {
      throw Exception('Client ID is empty');
    }
    final docSnapshot = await _firestore.collection('Clients').doc(clientId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() ?? {};
      return ClientModel.fromJson(data);
    } else {
      throw Exception('Client not found');
    }
  }

  // Получение волонтера по ID
  Future<VolunteerModel> getVolunteerById(String volunteerId) async {
    if (volunteerId.isEmpty) {
      throw Exception('Volunteer ID is empty');
    }
    final docSnapshot = await _firestore.collection('Volunteers').doc(volunteerId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() ?? {};
      return VolunteerModel.fromJson(data);
    } else {
      throw Exception('Volunteer not found');
    }
  }

  Future<String> getUserById(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID is empty');
    }
    final docSnapshot = await _firestore.collection('Users').doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() ?? {};
      return data['role'] as String;
    } else {
      throw Exception('User not found');
    }
  }

  // Получение задачи по ID
  Future<TaskModel> getTaskById(String taskId) async {
    final docSnapshot = await _firestore.collection('Tasks').doc(taskId).get();
    if (docSnapshot.exists) {
      final taskData = docSnapshot.data()!;
      final taskModel = TaskModel.fromJson(taskData);

      // Загрузка клиента
      final client = await getClientById(taskModel.taskClientId);

      // Загрузка волонтеров
      final volunteers = await Future.wait(taskModel.taskVolunteerIds.map(getVolunteerById));

      // Возвращаем полный объект TaskModel с загруженными данными
      return TaskModel(
        id: taskModel.id,
        taskName: taskModel.taskName,
        taskDescription: taskModel.taskDescription,
        taskComment: taskModel.taskComment,
        taskCategories: taskModel.taskCategories,
        taskClientId: taskModel.taskClientId,
        taskVolunteerIds: taskModel.taskVolunteerIds,
        taskVolunteersCount: taskModel.taskVolunteersCount,
        taskStartDate: taskModel.taskStartDate,
        taskStartTime: taskModel.taskStartTime,
        taskEndDate: taskModel.taskEndDate,
        taskAddress: taskModel.taskAddress,
        taskCoordinates: taskModel.taskCoordinates,
        taskStatus: taskModel.taskStatus,
        taskClient: client,
        taskVolunteers: volunteers,
      );
    } else {
      throw Exception('Task not found');
    }
  }

  // Получение всех задач
  Future<List<TaskModel>> getAllTasks() async {
    final querySnapshot = await _firestore.collection('Tasks').get();
    final tasks = querySnapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();

    // Загрузка клиентов и волонтеров для каждой задачи
    for (var task in tasks) {
      try {
        task.taskClient = await getClientById(task.taskClientId);
        task.taskVolunteers = await Future.wait(task.taskVolunteerIds.map(getVolunteerById));
      } catch (e) {
        if (kDebugMode) {
          print('Error loading task data: $e');
        }
      }
    }
    return tasks;
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Tasks').doc(taskId).update({
        'taskStatus': newStatus,
      });
    } catch (e) {
      throw Exception('Ошибка при обновлении статуса заявки: $e');
    }
  }

  Future<List<TaskModel>> getCompletedTasksForVolunteer(String volunteerId) async {
    if (volunteerId.isEmpty) {
      throw Exception('Volunteer ID is empty');
    }

    final querySnapshot = await _firestore.collection('Tasks')
        .where('taskVolunteerIds', arrayContains: volunteerId)
        .where('taskStatus', isEqualTo: 'Завершен')
        .get();

    final tasks = querySnapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();

    // Загрузка клиентов и волонтеров для каждой задачи
    for (var task in tasks) {
      try {
        task.taskClient = await getClientById(task.taskClientId);
        task.taskVolunteers = await Future.wait(task.taskVolunteerIds.map(getVolunteerById));
      } catch (e) {
        if (kDebugMode) {
          print('Error loading task data: $e');
        }
      }
    }
    return tasks;
  }
}