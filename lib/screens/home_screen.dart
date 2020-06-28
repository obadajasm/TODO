import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/provider/task.dart';
import 'package:todo/provider/theme.dart';
import 'package:todo/widget/task_admin.dart';

class MyHomePage extends StatefulWidget {
  static const String ROUTE_NAME = 'MyHomePage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TaskProvider _taskProvider;
  AuthProvider _authProvider;
  ThemeProvider _themeProvider;

  @override
  void didChangeDependencies() {
    // init the providers
    _taskProvider = Provider.of<TaskProvider>(context);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todos'),
        actions: [
          // icon to toogle the theme
          IconButton(
              icon: Icon(_themeProvider.currentThemeData == ThemeData.dark()
                  ? Icons.wb_sunny
                  : Icons.wb_cloudy),
              onPressed: () {
                _themeProvider.toogleTheme();
              }),

          // sign out from facebook or google account
          FlatButton(
              onPressed: () {
                _authProvider.signOut(context);
              },
              child: Text('sign out')),
        ],
      ),
      // future builder to await the getTasks futures
      body: FutureBuilder(
        // get the tasks
        future: _taskProvider.getTasks(),
        // builder method
        builder: (ctx, data) {
          return data.connectionState == ConnectionState.done
              // only if connection is done => build the list of todos
              ? ListView.builder(
                  itemCount: _taskProvider?.tasks?.length ?? 0,
                  itemBuilder: (ctx, index) {
                    return _buildTodoItem(_taskProvider.tasks[index], context);
                  })
              // show progressIndeicator while downloading
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildTodoItem(Task _currentTask, BuildContext context) {
    return Container(
      color: _currentTask.isDone
          ? Theme.of(context).primaryColor
          : Theme.of(context).splashColor,
      child: Dismissible(
        key: Key(_currentTask.id),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (dir) {
          // onDimis either directions the item will be deleted
          _taskProvider.deleteTask(_currentTask.id);
        },
        child: ListTile(
          onTap: () {
            // one tap to toogle the todo is done or not
            _taskProvider.toogleIsDone(_currentTask);
          },
          // on long press to edit this todo
          onLongPress: () {
            showTaskAdminDialog(
              title: _currentTask.title,
              desc: _currentTask.description,
              editeMode: true,
              currentTask: _currentTask,
            );
          },
          title: AutoSizeText(
            _currentTask?.title ?? '',
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: AutoSizeText(
            _currentTask?.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // add chech icon if the todo is done.
          trailing: _currentTask.isDone ? Icon(Icons.check) : SizedBox(),
        ),
      ),
    );
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        showTaskAdminDialog(
          editeMode: false,
        );
      },
      tooltip: 'add a  todo',
      child: Icon(Icons.add),
    );
  }

  void showTaskAdminDialog({title, desc, editeMode, currentTask}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return TaskTakerDialog(
            title: title,
            editMode: editeMode,
            desc: desc,
            currentTask: currentTask,
          );
        });
  }
}
