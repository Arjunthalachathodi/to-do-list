import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';
import 'package:to_do_list/domain/tasks/repositories/task_repository.dart';

@lazySingleton
class GetTasks {
  final TaskRepository _repository;
  GetTasks(this._repository);

  Future<Either<Failure, List<Task>>> call(String userId, String token) =>
      _repository.getTasks(userId, token);
}

@lazySingleton
class AddTask {
  final TaskRepository _repository;
  AddTask(this._repository);

  Future<Either<Failure, Unit>> call(String userId, Task task, String token) =>
      _repository.addTask(userId, task, token);
}

@lazySingleton
class UpdateTask {
  final TaskRepository _repository;
  UpdateTask(this._repository);

  Future<Either<Failure, Unit>> call(String userId, Task task, String token) =>
      _repository.updateTask(userId, task, token);
}

@lazySingleton
class DeleteTask {
  final TaskRepository _repository;
  DeleteTask(this._repository);

  Future<Either<Failure, Unit>> call(String userId, String taskId, String token) =>
      _repository.deleteTask(userId, taskId, token);
}
