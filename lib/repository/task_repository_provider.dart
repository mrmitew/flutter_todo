import 'package:flutter/material.dart';
import 'package:flutter_todo/repository/Repository.dart';

class TaskRepositoryProvider extends InheritedWidget {
  final TaskRepository taskRepository;

  const TaskRepositoryProvider({
    Key key,
    this.taskRepository,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static TaskRepositoryProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(TaskRepositoryProvider)
          as TaskRepositoryProvider;

  @override
  bool updateShouldNotify(TaskRepositoryProvider old) {
    return true;
  }
}
