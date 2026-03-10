import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';
import 'package:to_do_list/presentation/auth/bloc/auth_bloc.dart';
import 'package:to_do_list/presentation/tasks/bloc/task_bloc.dart';
import 'package:to_do_list/presentation/tasks/widgets/task_item.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(TaskEvent.refreshRequested(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Text(
                'My Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverFillRemaining(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                    loading: (_) => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                    loadSuccess: (e) {
                      if (e.tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks yet',
                                style: TextStyle(fontSize: 20, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a task to get started!',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      // Sort by uncompleted first, then by date
                      final sortedTasks = List<Task>.from(e.tasks)
                        ..sort((a, b) {
                          if (a.isCompleted == b.isCompleted) {
                            return b.createdAt.compareTo(a.createdAt);
                          }
                          return a.isCompleted ? 1 : -1;
                        });

                      return ListView.builder(
                        itemCount: sortedTasks.length,
                        padding: const EdgeInsets.only(top: 16, bottom: 100),
                        itemBuilder: (context, index) {
                          final task = sortedTasks[index];
                          return TaskItem(
                            task: task,
                            onToggle: () {
                              context.read<TaskBloc>().add(TaskEvent.taskUpdated(
                                    widget.userId,
                                    task.copyWith(isCompleted: !task.isCompleted),
                                  ));
                            },
                            onDelete: () {
                              context.read<TaskBloc>().add(TaskEvent.taskDeleted(widget.userId, task.id));
                            },
                            onEdit: () => _showAddTaskDialog(task),
                          );
                        },
                      );
                    },
                    loadFailure: (e) => Center(
                      child: Text(
                        'Failed to load tasks',
                        style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(null),
        elevation: 4,
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(Task? existingTask) {
    final titleController = TextEditingController(text: existingTask?.title);
    final descController = TextEditingController(text: existingTask?.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
         decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  existingTask == null ? 'Create New Task' : 'Edit Task',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                ),
                const SizedBox(height: 24),
                TextField(
                    controller: titleController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'What do you need to do?',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                ),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),
                TextField(
                    controller: descController,
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Add details (optional)',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.notes_rounded, color: Colors.grey.shade400, size: 20),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                    ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                          if (titleController.text.isNotEmpty) {
                              if (existingTask == null) {
                                  final task = Task(
                                      id: const Uuid().v4(),
                                      title: titleController.text,
                                      description: descController.text,
                                      createdAt: DateTime.now(),
                                  );
                                  this.context.read<TaskBloc>().add(TaskEvent.taskAdded(widget.userId, task));
                              } else {
                                  final updatedTask = existingTask.copyWith(
                                      title: titleController.text,
                                      description: descController.text,
                                  );
                                  this.context.read<TaskBloc>().add(TaskEvent.taskUpdated(widget.userId, updatedTask));
                              }
                              Navigator.pop(context);
                          }
                      },
                      child: Text(existingTask == null ? 'Save Task' : 'Update Task'),
                  ),
                ),
                const SizedBox(height: 12),
            ],
            ),
        ),
      ),
    );
  }
}

