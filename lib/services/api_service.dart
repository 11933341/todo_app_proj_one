import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class ApiService {
  final String baseUrl = 'http://csci4102025.atwebpages.com';

  // Fetch all tasks
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_tasks.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((task) => Task.fromJson(task)).toList();
      } else {
        print('Server error: ${response.statusCode}');
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  // Add a new task
  Future<bool> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_task.php'),
      body: {
        'title': task.title,
        'description': task.description,
        'tags': task.tags.join(','),
        'is_completed': task.isCompleted ? '1' : '0',
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['success'];
    } else {
      throw Exception('Failed to add task');
    }
  }

  // Update task completion status
  Future<bool> updateTaskCompletion(String id, bool isCompleted) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_task.php'),
        body: {
          'id': id,
          'is_completed': isCompleted ? '1' : '0', // Send completion status
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success']; // Check for success
      } else {
        print('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }


  // Delete a task
  Future<bool> deleteTask(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_task.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['success'];
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
