import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:cool_alert/cool_alert.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool varsementara = true;
  List<Todo> todos = dataTodo;
  @override
  Widget build(BuildContext context) {
    AppBar myAppBar = AppBar(
      title: Text("Todo App"),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
    double heightBody = MediaQuery.of(context).size.height -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double widthBody = MediaQuery.of(context).size.width;
    // var coba = Hive.box("todos");
  //  print(coba.get('title'));
    // function search
    void searchTodo(String query) {
      final todoFilter = dataTodo.where((todo) {
        final todoTitle = todo.title.toLowerCase();
        final input = query.toLowerCase();
        return todoTitle.contains(input);
      }).toList();
      setState(() {
        todos = todoFilter;
      });
    }

    ;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "add_todo");
          },
          child: Icon(Icons.add),
        ),
        appBar: myAppBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: heightBody * 0.15,
                width: widthBody,
                child: TextField(
                    onChanged: searchTodo,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search Your Task ...")),
              ),
              todos.length != 0
                  ? Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      height: heightBody * 0.85,
                      width: widthBody,
                      child: ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: ((context, index) {
                            final todo = todos[index];
                            return CheckboxListTile(
                                secondary: IconButton(
                                  onPressed: () {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      text: "sure the data will be deleted ?",
                                      onConfirmBtnTap: () {
                                        setState(() {
                                          todos.removeAt(index);
                                        });
                                        Navigator.pop(context);
                                        CoolAlert.show(context: context, type: CoolAlertType.success);
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                subtitle: Text(todo.desc),
                                value: todo.isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    todo.isCompleted = value!;
                                  });
                                });
                          })),
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: heightBody * 0.85,
                      width: widthBody,
                      child: Text("Data Kosong"),
                    ),
            ],
          ),
        ));
  }
}
