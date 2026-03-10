import 'package:dartz/dartz.dart' hide Task;
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks(String userId, String token);
  Future<Either<Failure, Unit>> addTask(String userId, Task task, String token);
  Future<Either<Failure, Unit>> updateTask(String userId, Task task, String token);
  Future<Either<Failure, Unit>> deleteTask(String userId, String taskId, String token);
}
