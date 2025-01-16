class Task {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  bool isCompleted; // Make it mutable to toggle the status

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.tags = const [],
    this.isCompleted = false, // Default to not completed
  });

  // Convert the Task to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'tags': tags,
        'isCompleted': isCompleted,
      };

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'].toString(), // Convert id to a string
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        tags: json['tags'] != null
            ? List<String>.from(json['tags'].split(',').map((e) => e.trim()))
            : [],
        isCompleted: json['isCompleted'] == 1 || json['isCompleted'] == true,
      );
}
