import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/domain/tasks/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: onDelete,
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Status Icon with Animated Color
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        task.isCompleted ? Icons.check_rounded : Icons.radio_button_unchecked,
                        color: task.isCompleted ? Colors.green : AppTheme.primaryColor,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  
                  // Task Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : const Color(0xFF1A1C1E),
                              ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, hh:mm a').format(task.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Small Action Menu
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300, size: 22),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.05),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

