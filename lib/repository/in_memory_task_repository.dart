import 'dart:async';

import 'package:flutter_todo/repository/Repository.dart';

class InMemoryTaskRepository extends TaskRepository {
  final StreamController<List<Task>> _streamController =
      StreamController<List<Task>>();

  final List<Task> taskList = [
    Task(DateTime.now().millisecondsSinceEpoch, "Test"),
  ];

  InMemoryTaskRepository() {
    Future.delayed(Duration(milliseconds: 1500), () {
      return Future(() {
        _streamController.add(taskList);
      });
    });
  }

  @override
  Future<void> addTask(Task task) async {
    taskList.add(task);
    _streamController.add(taskList);
  }

  @override
  Stream<List<Task>> tasksStream() => _streamController.stream;

  @override
  Future<void> deleteTask(Task task) async {
    taskList.remove(task);
    _streamController.add(taskList);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
