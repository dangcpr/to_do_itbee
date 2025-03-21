class NameEntity {
  static const String tasks = 'tasks';
}

class AppConst {
  static const String emptyTaskImage = 'assets/images/empty_task.png';
}

enum Status {
  todo,
  done,
  all;

  factory Status.fromInt(int value) => Status.values[value];

  String nameStatus() {
    switch (this) {
      case Status.todo:
        return 'To Do';
      case Status.done:
        return 'Done';
      case Status.all:
        return 'All';
    }
  }

  Status switchStatus() {
    switch (this) {
      case Status.todo:
        return Status.done;
      case Status.done:
        return Status.todo;
      case Status.all:
        return Status.all;
    }
  }
}
