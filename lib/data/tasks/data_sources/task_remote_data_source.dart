import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list/core/constants/firebase_constants.dart';
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';

import 'package:injectable/injectable.dart';

abstract class TaskRemoteDataSource {
  Future<List<Task>> getTasks(String userId, String token);
  Future<void> addTask(String userId, Task task, String token);
  Future<void> updateTask(String userId, Task task, String token);
  Future<void> deleteTask(String userId, String taskId, String token);
}

@LazySingleton(as: TaskRemoteDataSource)
class FirebaseTaskDataSource implements TaskRemoteDataSource {
  final http.Client client;

  FirebaseTaskDataSource(this.client);

  @override
  Future<List<Task>> getTasks(String userId, String token) async {
    final response = await client.get(
      Uri.parse('${FirebaseConstants.databaseUrl}/users/$userId/tasks.json?auth=$token'),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData == null) return [];
      
      final List<Task> tasks = [];
      (decodedData as Map<String, dynamic>).forEach((id, data) {
        tasks.add(Task.fromJson({...data, 'id': id}));
      });
      return tasks;
    } else {
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> addTask(String userId, Task task, String token) async {
    final response = await client.post(
      Uri.parse('${FirebaseConstants.databaseUrl}/users/$userId/tasks.json?auth=$token'),
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> updateTask(String userId, Task task, String token) async {
    final response = await client.patch(
      Uri.parse('${FirebaseConstants.databaseUrl}/users/$userId/tasks/${task.id}.json?auth=$token'),
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId, String token) async {
    final response = await client.delete(
      Uri.parse('${FirebaseConstants.databaseUrl}/users/$userId/tasks/$taskId.json?auth=$token'),
    );

    if (response.statusCode != 200) {
      throw const Failure.serverError();
    }
  }
}
