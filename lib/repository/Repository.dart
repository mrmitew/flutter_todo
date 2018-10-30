import 'dart:async';

abstract class TaskRepository extends Repository {
  Future<void> addTask(Task task);

  Future<void> deleteTask(Task task);

  Stream<List<Task>> tasksStream();
}

class Task {
  final int id;
  final String title;

  Task(this.id, this.title);
}

abstract class Repository {
  void dispose();
}
