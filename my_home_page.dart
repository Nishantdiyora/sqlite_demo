import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_demo/my_home_page_controller.dart';
import 'package:sqlite_demo/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? taskController = TextEditingController();
  TextEditingController? descController = TextEditingController();
  List<int> items = List<int>.generate(20, (int index) => index);
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var homePageController = Get.put(MyHomePageContoller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqlite"),
      ),
      body: Obx(
        () => ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Dismissible(
                  background: Container(
                    color: Colors.indigoAccent,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: ValueKey<int>(items[index]),
                  onDismissed: (DismissDirection direction) {
                    homePageController.deleteTodo(
                        id: homePageController.todoList[index].id);
                  },
                  child: ListTile(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        await buildShowModalBottomSheet(context,
                            isUpdate: true,
                            id: homePageController.todoList[index].id);
                        nameController!.text =
                            homePageController.todoList[index].name!;
                        taskController!.text =
                            homePageController.todoList[index].task!;
                        descController!.text =
                            homePageController.todoList[index].desc!;
                      },
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${homePageController.todoList[index].id}"),
                        Text("${homePageController.todoList[index].name}"),
                        Text("${homePageController.todoList[index].task}"),
                        Text("${homePageController.todoList[index].desc}"),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: homePageController.todoList.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await buildShowModalBottomSheet(context, isUpdate: false);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context,
      {required bool isUpdate, String? id}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: 800,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Name";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Name",
                            labelText: "name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        controller: nameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter Task";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Task",
                          labelText: "Task",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: taskController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter description";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Description",
                            labelText: "Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        controller: descController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            if (isUpdate == false) {
                              homePageController.addData(
                                  name: nameController!.text,
                                  task: taskController!.text,
                                  desc: descController!.text);
                            } else {
                              homePageController.updateTodo(TodoModel(
                                id: id!,
                                name: nameController!.text,
                                task: taskController!.text,
                                desc: descController!.text,
                              ));
                            }
                            Navigator.pop(context);
                            nameController!.clear();
                            taskController!.clear();
                            descController!.clear();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
