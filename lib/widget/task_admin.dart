import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task.dart';
import 'package:todo/provider/task.dart';

class TaskTakerDialog extends StatefulWidget {
  const TaskTakerDialog({
    this.desc = '',
    this.title = '',
    this.editMode,
    this.currentTask,
    Key key,
  }) : super(key: key);
  final String title;
  final String desc;
  final bool editMode;
  final Task currentTask;
  @override
  _TaskTakerDialogState createState() => _TaskTakerDialogState();
}

class _TaskTakerDialogState extends State<TaskTakerDialog> {
  String _title = '';
  String _desc = '';
  TaskProvider _taskProvider;

  @override
  void didChangeDependencies() {
    _taskProvider = Provider.of<TaskProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      children: [
        Text('enter your todo title'),
        TextField(
          controller: TextEditingController()..text = widget.title,
          onChanged: (s) {
            _title = s;
          },
        ),
        SizedBox(height: 50),
        Text('enter your todo description'),
        TextField(
          controller: TextEditingController()..text = widget.desc,
          maxLines: 2,
          onChanged: (s) {
            _desc = s;
          },
        ),
        SizedBox(height: 50),
        FlatButton(
            onPressed: () async {
              widget.editMode
                  ? await _taskProvider.editTask(
                      _title, _desc, widget.currentTask)
                  : await _taskProvider.addTask(_title, _desc);
              Navigator.of(context).pop();
            },
            child: Text('save'))
      ],
    );
  }
}
