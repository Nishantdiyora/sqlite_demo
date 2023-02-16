class TodoModel {
  String? id;
  String? name;
  String? task;
  String? desc;

  TodoModel({this.id, this.name, this.task, this.desc});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    task = json['task'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['task'] = this.task;
    data['desc'] = this.desc;
    return data;
  }
}
