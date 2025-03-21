import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:to_do_itbee/core/extension.dart';
import 'package:to_do_itbee/core/function.dart';
import 'package:to_do_itbee/domain/entities/to_do_entity.dart';
import 'package:to_do_itbee/presentation/home/provider/update_to_do_status_provider.dart';

import '../../../core/const.dart';
import '../../../domain/usecases/to_do_usecase.dart';
import '../../../service_locator.dart';
import '../../create_to_do/pages/create_to_do_page.dart';
import '../../update_to_do/pages/update_to_do_page.dart';
import '../provider/delete_to_do_provider.dart';
import '../provider/get_to_do_list_provider.dart';
import '../widgets/empty_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Status status;

  final getToDoListProvider = sl.get<GetToDoListProvider>();

  @override
  void initState() {
    super.initState();
    status = Status.all;
    getToDoListProvider.getToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetToDoListProvider>(
      create: (_) => getToDoListProvider,
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text("All"),
                    selected: status == Status.all,
                    onSelected: (value) async {
                      setState(() {
                        status = Status.all;
                      });
                      await getToDoListProvider.getToDoList();
                    },
                  ),
                  ChoiceChip(
                    label: Text("To Do"),
                    selected: status == Status.todo,
                    onSelected: (value) async {
                      setState(() {
                        status = Status.todo;
                      });
                      await getToDoListProvider.getToDoList(
                        status: Status.todo,
                      );
                    },
                  ),
                  ChoiceChip(
                    label: Text("Done"),
                    selected: status == Status.done,
                    onSelected: (value) async {
                      setState(() {
                        status = Status.done;
                      });
                      await getToDoListProvider.getToDoList(
                        status: Status.done,
                      );
                    },
                  ),
                ],
              ),
              Consumer<GetToDoListProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (value.errorMessage.isNotEmpty) {
                    return Center(child: Text(value.errorMessage));
                  }
                  if (value.toDoList.isEmpty) {
                    return EmptyWidget(status: status);
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: value.toDoList.length,
                      itemBuilder: (context, index) {
                        final toDo = value.toDoList[index];
                        return _buildItem(toDo);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              PageTransition(
                child: const CreateToDoPage(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(ToDoEntity toDo) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
      title: Text(
        toDo.title,
        style: TextStyle(
          decoration:
              Status.fromInt(toDo.status) == Status.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      ),
      leading: ChangeNotifierProvider<UpdateToDoStatusProvider>(
        create: (_) => UpdateToDoStatusProvider(sl.get<ToDoUsecase>()),
        child: Consumer<UpdateToDoStatusProvider>(
          builder: (_, value, __) {
            return InkWell(
              onTap: () async {
                await onTapUpdate(
                  toDo.id,
                  Status.fromInt(toDo.status).switchStatus(),
                  value,
                );
                if (value.errorMessage.isEmpty) {
                  setState(() {
                    toDo.status =
                        Status.fromInt(toDo.status).switchStatus().index;
                  });
                }
              },
              child:
                  value.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                      : Icon(
                        Status.fromInt(toDo.status) == Status.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
            );
          },
        ),
      ),
      subtitle: Text(
        '${toDo.dueDate.formatDate()} at ${toDo.dueDate.formatTime(MediaQuery.of(context).alwaysUse24HourFormat)}',
        style: TextStyle(
          fontSize: 14,
          decoration:
              Status.fromInt(toDo.status) == Status.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  child: UpdateToDoPage(toDo: toDo),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onTapDelete(toDo.id),
          ),
        ],
      ),
    );
  }

  Future<void> onTapUpdate(
    int? id,
    Status status,
    UpdateToDoStatusProvider provider,
  ) async {
    if (id == null) {
      AppFunctions.snackMessage(context, "To Do id is null");
      return;
    }
    await provider.update(id, status);
    if (provider.errorMessage.isNotEmpty) {
      // ignore: use_build_context_synchronously
      AppFunctions.snackMessage(context, provider.errorMessage);
      return;
    }
  }

  Future<void> onTapDelete(int? id) async {
    if (id == null) {
      AppFunctions.snackMessage(context, "To Do id is null");
      return;
    }
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
            ChangeNotifierProvider<DeleteToDoProvider>(
              create:
                  (_) =>
                      DeleteToDoProvider(sl.get<ToDoUsecase>()..deleteToDo(id)),
              child: Consumer<DeleteToDoProvider>(
                builder: (_, value, __) {
                  if (value.isLoading) {
                    return TextButton(
                      onPressed: null,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (value.errorMessage.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppFunctions.snackMessage(context, value.errorMessage);
                    });
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppFunctions.snackMessage(context, "Task deleted successfully");
                  });
                  return TextButton(
                    child: const Text('Yes'),
                    onPressed: () async {
                      await value.deleteToDo(id);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      await getToDoListProvider.getToDoListWithCurrentStatus();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
