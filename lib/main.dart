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
  final TaskController taskManager =
      TaskController(); // Create TaskManager instance
  List<Task> taskList = []; // Holds the list of tasks
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the app starts
  }

  // Fetch tasks and update the state
  void _loadTasks() async {
    setState(() => isLoading = true); // Start loading
    await taskManager.fetchTasks(); // Fetch tasks from server
    setState(() {
      taskList = taskManager.taskList; // Update UI with fetched tasks
      isLoading = false; // Stop loading
    });
  }

  // Add a new task
  void _addTask(Task task) async {
    setState(() => isLoading = true); // Show loading indicator
    final success = await taskManager.addTask(task);
    setState(() => isLoading = false); // Stop loading indicator

    final message = success ? 'Task added successfully!' : 'Failed to add task';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (success) {
      _loadTasks(); // Reload tasks after adding
    }
  }

  // Toggle task completion
  void _toggleTaskCompletion(String id) async {
    setState(() => isLoading = true); // Start the loading indicator
    final success = await taskManager.toggleTaskCompletion(id); // Toggle the completion
    setState(() => isLoading = false); // Stop the loading indicator

    // Show a snackbar to notify the user
    final message = success ? 'Task updated successfully!' : 'Failed to update task';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (success) {
      setState(() {
        taskList = taskManager.taskList; // Update the local task list
        print('Updated Task List: $taskList'); // Log for debugging
      });
    }
  }


  // Delete a task
  void _deleteTask(String id) async {
    setState(() => isLoading = true);
    final success = await taskManager.removeTask(id);
    setState(() => isLoading = false);

    final message =
        success ? 'Task deleted successfully!' : 'Failed to delete task';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (success) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show spinner while loading
          : TaskListScreen(
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
