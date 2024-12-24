import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'To-Do App 2'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _tasks = []; // List to store tasks
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    setState(() {
      if (_taskController.text.isNotEmpty) {
        setState(() {
          _tasks.add(_taskController.text);
        });
        _taskController.clear();
        Navigator.of(context).pop();
      }

    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('To-do App 3'),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add Task'),
                        content: TextField(
                          controller: _taskController,
                          decoration:
                              InputDecoration(hintText: 'Enter task name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('cancel'),
                          ),
                          TextButton(onPressed: _addTask, child: Text('Add'))
                        ],
                      );
                    })
              },
              child: Icon(Icons.add),
              ),
    );
  }
}
