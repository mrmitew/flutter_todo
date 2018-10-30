import 'package:flutter/material.dart';
import 'package:flutter_todo/repository/Repository.dart';
import 'package:flutter_todo/repository/firebase_realtime_task_repository.dart';
import 'package:flutter_todo/repository/task_repository_provider.dart';
import 'package:flutter_todo/ui/three_way_list_items_builder.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskRepositoryProvider(
        taskRepository: FirebaseRealtimeTaskRepository(),
        child: TodoApp(),
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  TodoAppState createState() {
    return TodoAppState();
  }
}

class TodoAppState extends State<TodoApp> with SingleTickerProviderStateMixin {
  TaskRepository taskRepository;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _bottomSheetController;

  AnimationController animationController;

  Animation<double> animation;

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskRepository = TaskRepositoryProvider.of(context).taskRepository;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Todo"),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: StreamBuilder(
          stream: taskRepository.tasksStream(),
          builder: (context, snapshot) => ThreeWayListItemsBuilder<Task>(
                items: snapshot.data,
                itemWidgetBuilder: (context, item) => Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                          color: Theme.of(context).accentColor,
                          child: const ListTile(
                              trailing: Icon(Icons.delete,
                                  color: Colors.white, size: 36.0))),
                      key: ObjectKey(item),
                      onDismissed: (direction) {
                        taskRepository.deleteTask(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).dividerColor))),
                        child: ListTile(
                          title: Text(item.title),
                        ),
                      ),
                    ),
                placeholderWidgetBuilder: (context) => PlaceholderContent(),
              )),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: animation,
      child: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAddTodoDialog() {
    animationController.reverse();

    _bottomSheetController =
        _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 100.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    icon: Icon(Icons.note_add),
                    hintText: 'Enter a task',
                    labelText: 'Task',
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  "ADD",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.blueGrey),
                ),
                onPressed: () {
                  if (mounted) {
                    _bottomSheetController.close();
                  }

                  if (_textEditingController.text.length > 0) {
                    taskRepository.addTask(Task(
                        DateTime.now().millisecondsSinceEpoch,
                        _textEditingController.text));
                    _textEditingController.text = "";
                  }
                },
              )
            ],
          ),
        ),
        color: Colors.blue[100],
      );
    });

    _bottomSheetController.closed.whenComplete(() {
      if (mounted) {
        animationController.forward();
      }
    });
  }
}
