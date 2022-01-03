// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskist/model/my_theme_provider.dart';

// Project imports:
import 'package:taskist/model/todo.dart';
import 'package:taskist/util/app_constant.dart';
import 'package:taskist/util/dbhelper.dart';

DbHelper helper = DbHelper();

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  final _priorities = ["Urgent", "High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    isEdit = todo.title == '' ? false : true;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
  }

  TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      fontFamily: 'Manrope', // Manrope
      color: Color(0xFF767B83),
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBarWidget(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    color: Color(0xFFB0CCE1).withOpacity(0.32),
                  ),
                ],
              ),

              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15.0,
                      spreadRadius: -5.0,
                      offset: Offset(0.0, 7.0)),
                ],
              ),*/
              width: 320.0,
              height: 370.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                          maxLength: 30,
                          onSaved: (value) {
                            todo.title = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Title cannot be null';
                            }

                            if (value.length > 30) {
                              return 'Max length for title is 30.';
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          style: textStyle,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: textStyle,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            labelStyle: textStyle,
                          )),
                      TextFormField(
                          maxLength: 50,
                          onSaved: (value) {
                            todo.description = value;
                          },
                          keyboardType: TextInputType.text,
                          controller: descriptionController,
                          style: textStyle,
                          decoration: InputDecoration(
                            hintText: 'Specific content',
                            hintStyle: textStyle,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            labelStyle: textStyle,
                          )),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          labelStyle: textStyle,
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: _priorities.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: textStyle,
                            value: retrievePriority(todo.priority),
                            onChanged: (value) => updatePriority(value),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(13.0),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: AppConstant.colorPrimary,
                        onPressed: () => save(),
                        child: Text(
                          isEdit ? "Edit" : "Add",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isEdit
          ? FloatingActionButton(
              onPressed: () {
                debugPrint("Click Floated Back.");
                confirmDelete();
              },
              elevation: 5.0,
              backgroundColor: AppConstant.colorDelete,
              tooltip: "Cancel",
              child: new Icon(Icons.clear, size: 35.0, color: Colors.white))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //
  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        isEdit ? "Edit Task" : "New Task",
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20, // 22
          fontFamily: 'Manrope', // Manrope
          letterSpacing: 2,
        ),
      ),
      actions: [themeModeButton(context)],
    );
  }

  // Light-Dark
  Padding themeModeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<MyThemeModel>(
        builder: (context, theme, child) => InkWell(
          onTap: () => theme.changeTheme(),
          child: SvgPicture.asset(
            theme.isLightTheme ? AppConstant.svgSun : AppConstant.svgMoon,
            height: 22,
            width: 22,
            color: AppConstant.colorPrimary,
          ),
        ),
      ),
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are you sure about deleting this task?",
            style: TextStyle(fontSize: 15.0)),
        actions: <Widget>[
          new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop()),
          new FlatButton(
              child: new Text(
                'DELETE',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                helper.deleteTodo(todo.id);
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

  void save() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      todo.date = new DateFormat.yMd().format(DateTime.now());
      if (todo.id != null) {
        helper.updateTodo(todo);
      } else {
        helper.insertTodo(todo);
      }
      Navigator.pop(context, true);
    }
  }

  void updatePriority(String value) {
    switch (value) {
      case 'Urgent':
        todo.priority = 1;
        break;
      case 'High':
        todo.priority = 2;
        break;
      case 'Medium':
        todo.priority = 3;
        break;
      case 'Low':
        todo.priority = 4;
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    setState(() {
      todo.title = titleController.text;
    });
  }

  void updateDescription() {
    setState(() {
      todo.description = descriptionController.text;
    });
  }
}
