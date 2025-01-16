import 'package:flutter/material.dart';
import 'models/task.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
import 'state/task_manager.dart';
import 'widgets/task_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: TaskManager(),
    );
  }
}

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}



class _TaskManagerState extends State<TaskManager> {
  final TaskController taskManager = TaskController(); // Create TaskManager instance
  List<Task> taskList = []; // Holds the list of tasks

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the app starts
  }

  // Fetch tasks and update the state
  void _loadTasks() async {
    await taskManager.fetchTasks(); // Fetch from server
    setState(() {
      taskList = taskManager.taskList; // Update local list
    });
  }

  // Add a new task
  void _addTask(Task task) async {
    final success = await taskManager.addTask(task);
    if (success) {
      _loadTasks(); // Reload tasks after adding
    }
  }

  // Toggle task completion
  void _toggleTaskCompletion(String id) async {
    final success = await taskManager.toggleTaskCompletion(id);
    if (success) {
      _loadTasks(); // Reload tasks after toggling
    }
  }

  // Delete a task
  void _deleteTask(String id) async {
    final success = await taskManager.removeTask(id);
    if (success) {
      _loadTasks(); // Reload tasks after deleting
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: TaskListScreen(
        taskList: taskList,
        onDeleteTask: _deleteTask,
        onToggleTaskCompletion: _toggleTaskCompletion,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onAddTask: (task) {
                  _addTask(task); // Add the task
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}




class AddTaskScreen extends StatelessWidget {
  final Function(Task) onAddTask;

  AddTaskScreen({required this.onAddTask});

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(labelText: 'Tags (comma-separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  tags: _tagsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                );
                onAddTask(newTask); // Add the task
                Navigator.pop(context); // Return to task list
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}



