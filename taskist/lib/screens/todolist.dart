// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:taskist/model/todo.dart';
import 'package:taskist/screens/tododetail.dart';
import 'package:taskist/util/app_constant.dart';
import 'package:taskist/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: todoListItems(),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppConstant.colorPrimary,
          onPressed: () {
            navigateToDetail(Todo('', 3, ''));
          },
          tooltip: "Add new Task",
          child: new Icon(
            Icons.add,
            color: Colors.white,
            size: 35.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            padding: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 235, 235, 243),
                    blurRadius: 10.0,
                    spreadRadius: -9.0,
                    offset: Offset(0.0, 7.0)),
              ],
            ),
            child: Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 50.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete_sweep, color: Colors.white),
                      Text(
                        "remove",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              key: Key(todos[position].id.toString()),
              onDismissed: (direction) {
                int id = todos[position].id;
                String title = todos[position].title.toString();
                setState(() {
                  todos.removeAt(position);
                  helper.deleteTodo(id);
                  getData();
                });

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Todo: $title removed"),
                ));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  shadowColor: Color(0xFFB0CCE1).withOpacity(0.32),  // Change this 
                  elevation: 0.0,
                  child: ListTile(
                    // TODO: Find the way to align this avatar to top left corner
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 7.0,
                            backgroundColor: getColor(todos[position].priority),
                          ),
                        ],
                      ),
                    ),

                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        todos[position].title,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w800),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          descriptionParser(todos[position].description),
                          //  todos[position].description != null ? todos[position].description : 'Empty content',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                        ),
                        SizedBox(
                          height: 15.0,
                        ), // it smell
                        Text(
                          'Created at ' + todos[position].date,
                          style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 20.0),
                    // contentPadding: EdgeInsets.zero,
                    isThreeLine: true,
                    onTap: () {
                      debugPrint("Tapped on " + todos[position].id.toString());
                      navigateToDetail(todos[position]);
                    },
                  )),
            ),
          );
        });
  }

  String descriptionParser(String desc) {
    if (desc.length != 0) {
      return desc.length > 42 ? desc.substring(0, 42) + '...' : desc;
    }
    return '...';
  }

  void getData() {
    final dbFuture = helper.initalizeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        for (int i = 0; i < result.length; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
        });
        debugPrint("Items: " + todos.length.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return AppConstant.colorPriorityUrgent;
        break;
      case 2:
        return AppConstant.colorPriorityHigh;
        break;
      case 3:
        return AppConstant.colorPriorityMedium;
        break;
      case 4:
        return AppConstant.colorPriorityLow;
        break;

      default:
        return AppConstant.colorPriorityLow;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );

    if (result == true) {
      getData();
    }
  }
}
