part of 'task_bloc.dart';

@freezed
class TaskEvent with _$TaskEvent {
  const factory TaskEvent.refreshRequested(String userId) = _RefreshRequested;
  const factory TaskEvent.taskAdded(String userId, Task task) = _TaskAdded;
  const factory TaskEvent.taskUpdated(String userId, Task task) = _TaskUpdated;
  const factory TaskEvent.taskDeleted(String userId, String taskId) = _TaskDeleted;
}
