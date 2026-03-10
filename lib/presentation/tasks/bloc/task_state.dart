part of 'task_bloc.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;
  const factory TaskState.loading() = _Loading;
  const factory TaskState.loadSuccess(List<Task> tasks) = _LoadSuccess;
  const factory TaskState.loadFailure(Failure failure) = _LoadFailure;
}
