import 'dart:async';

import 'package:flutter_todo/repository/Repository.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeTaskRepository extends TaskRepository {
  static final String _rootPath = 'tasks';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  final StreamController<List<Task>> _streamController =
      StreamController<List<Task>>();

  @override
  Future<void> addTask(Task task) async {
    await _databaseTaskReference(task).set(task.title);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _databaseTaskReference(task).remove();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Stream<List<Task>> tasksStream() => _databaseReference().onValue.map((event) {
        Map<dynamic, dynamic> values = event.snapshot.value;

        return values != null
            ? values.keys
                .map((key) => Task(int.parse(key), values[key]))
                .toList()
            : [];
      });

  DatabaseReference _databaseTaskReference(Task task) =>
      FirebaseDatabase.instance.reference().child('$_rootPath/${task.id}');

  DatabaseReference _databaseReference() =>
      FirebaseDatabase.instance.reference().child('$_rootPath/');
}
