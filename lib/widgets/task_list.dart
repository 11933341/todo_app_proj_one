import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> taskList;
  final Function(String) onDeleteTask;
  final Function(String) onToggleTaskCompletion;

  TaskListScreen({
    required this.taskList,
    required this.onDeleteTask,
    required this.onToggleTaskCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                onToggleTaskCompletion(task.id);
              }
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              Wrap(
                children:
                task.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Task'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child:
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
              if (shouldDelete == true) {
                onDeleteTask(task.id);
              }
            },
          ),
        );
      },
    );
  }
}