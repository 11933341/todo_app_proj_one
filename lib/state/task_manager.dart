// File: lib/state/task_manager.dart

import '../models/task.dart'; // Import the Task model
import '../services/api_service.dart'; // Import the API service

class TaskController {
  final ApiService _apiService = ApiService(); // API service instance
  List<Task> _taskList = []; // List of tasks

  // Get the current list of tasks
  List<Task> get taskList => _taskList;

  // Fetch tasks from the server
  Future<void> fetchTasks() async {
    try {
      _taskList = await _apiService.fetchTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  // Add a new task
  Future<bool> addTask(Task task) async {
    try {
      final success = await _apiService.addTask(task);
      if (success) {
        await fetchTasks(); // Reload tasks
      }
      return success;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }


  // Remove a task by its ID
  Future<bool> removeTask(String id) async {
    final success = await _apiService.deleteTask(id);
    if (success) {
      await fetchTasks(); // Reload tasks from the server
    }
    return success;
  }

  // Toggle task completion
  Future<bool> toggleTaskCompletion(String id) async {
    final task = _taskList.firstWhere((task) => task.id == id);
    final success = await _apiService.updateTaskCompletion(id, !task.isCompleted);
    if (success) {
      await fetchTasks(); // Reload tasks from the server
    }
    return success;
  }
}
