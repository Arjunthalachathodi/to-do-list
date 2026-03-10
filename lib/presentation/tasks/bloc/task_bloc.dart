import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';
import 'package:injectable/injectable.dart';
import 'package:to_do_list/domain/auth/usecases/auth_usecases.dart';
import 'package:to_do_list/domain/tasks/usecases/task_usecases.dart';

part 'task_event.dart';
part 'task_state.dart';
part 'task_bloc.freezed.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks _getTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final GetToken _getToken;

  TaskBloc(
    this._getTasks,
    this._addTask,
    this._updateTask,
    this._deleteTask,
    this._getToken,
  ) : super(const TaskState.initial()) {
    on<TaskEvent>((event, emit) async {
      // Helper to get token or return failure
      Future<String?> getToken() async {
        final failureOrToken = await _getToken();
        return failureOrToken.getOrElse(() => null);
      }

       await event.map(
        refreshRequested: (e) async {
          emit(const TaskState.loading());
          final token = await getToken();
          if (token == null) {
            emit(const TaskState.loadFailure(const Failure.authenticationFailure('Not authenticated')));
            return;
          }
          final failureOrTasks = await _getTasks(e.userId, token);
          failureOrTasks.fold(
            (l) => emit(TaskState.loadFailure(l)),
            (r) => emit(TaskState.loadSuccess(r)),
          );
        },
        taskAdded: (e) async {
          final token = await getToken();
          if (token == null) return;
          final failureOrSuccess = await _addTask(e.userId, e.task, token);
          failureOrSuccess.fold(
            (l) => emit(TaskState.loadFailure(l)),
            (r) => add(TaskEvent.refreshRequested(e.userId)),
          );
        },
        taskUpdated: (e) async {
          final token = await getToken();
          if (token == null) return;
          final failureOrSuccess = await _updateTask(e.userId, e.task, token);
          failureOrSuccess.fold(
            (l) => emit(TaskState.loadFailure(l)),
            (r) => add(TaskEvent.refreshRequested(e.userId)),
          );
        },
        taskDeleted: (e) async {
          final token = await getToken();
          if (token == null) return;
          final failureOrSuccess = await _deleteTask(e.userId, e.taskId, token);
          failureOrSuccess.fold(
            (l) => emit(TaskState.loadFailure(l)),
            (r) => add(TaskEvent.refreshRequested(e.userId)),
          );
        },
      );
    });
  }
}
