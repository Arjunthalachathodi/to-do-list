import 'package:dartz/dartz.dart' hide Task;
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/data/tasks/data_sources/task_remote_data_source.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';
import 'package:to_do_list/domain/tasks/repositories/task_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Task>>> getTasks(String userId, String token) async {
    try {
      final tasks = await remoteDataSource.getTasks(userId, token);
      return right(tasks);
    } on Failure catch (e) {
      return left(e);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTask(String userId, Task task, String token) async {
    try {
      await remoteDataSource.addTask(userId, task, token);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(String userId, Task task, String token) async {
    try {
      await remoteDataSource.updateTask(userId, task, token);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String userId, String taskId, String token) async {
    try {
      await remoteDataSource.deleteTask(userId, taskId, token);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }
}
