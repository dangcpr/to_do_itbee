import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:to_do_itbee/core/extension.dart';

import '../../../core/const.dart';
import '../../../core/function.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../../domain/usecases/to_do_usecase.dart';
import '../../../service_locator.dart';
import '../../update_to_do/pages/update_to_do_page.dart';
import '../provider/delete_to_do_provider.dart';
import '../provider/get_to_do_list_provider.dart';
import '../provider/update_to_do_status_provider.dart';

class TaskWidget extends StatelessWidget {
  final ToDoEntity toDo;
  final GetToDoListProvider getToDoListProvider;

  const TaskWidget({
    super.key,
    required this.toDo,
    required this.getToDoListProvider,
  });

  @override
  Widget build(BuildContext context) {
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
                create: (_) => DeleteToDoProvider(sl.get<ToDoUsecase>()),
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
                    return TextButton(
                      child: const Text('Yes'),
                      onPressed: () async {
                        SchedulerBinding.instance.addPostFrameCallback((
                          _,
                        ) async {
                          await value.deleteToDo(id);
                          if (value.errorMessage.isEmpty && !value.isLoading) {
                            AppFunctions.snackMessage(
                              // ignore: use_build_context_synchronously
                              context,
                              "Task deleted successfully",
                            );
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          await getToDoListProvider
                              .getToDoListStatusSearchCurrent();
                        });
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

    void onTapDetail(ToDoEntity toDo) {
      Widget buildItem({required String text, required Icon icon}) {
        return Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        );
      }

      showModalBottomSheet(
        context: context,
        builder:
            (_) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    toDo.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildItem(
                    text: "Description: ${toDo.description}",
                    icon: const Icon(Icons.info),
                  ),
                  const SizedBox(height: 10),
                  buildItem(
                    text:
                        "Due Date: ${toDo.dueDate.formatDate()} at ${toDo.dueDate.formatTime(MediaQuery.of(context).alwaysUse24HourFormat)}",
                    icon: const Icon(Icons.calendar_month),
                  ),
                  const SizedBox(height: 10),
                  buildItem(
                    text: "Status: ${Status.fromInt(toDo.status).nameStatus()}",
                    icon:
                        Status.fromInt(toDo.status) == Status.done
                            ? const Icon(Icons.check_circle)
                            : const Icon(Icons.radio_button_unchecked),
                  ),
                  const SizedBox(height: 10),
                  buildItem(
                    text:
                        "Created At: ${toDo.createdAt.formatDate()} at ${toDo.createdAt.formatTime(MediaQuery.of(context).alwaysUse24HourFormat)}",
                    icon: const Icon(Icons.calendar_month),
                  ),
                  const SizedBox(height: 10),
                  buildItem(
                    text:
                        "Updated At: ${toDo.updatedAt.formatDate()} at ${toDo.updatedAt.formatTime(MediaQuery.of(context).alwaysUse24HourFormat)}",
                    icon: const Icon(Icons.calendar_month),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
      );
    }

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
                await getToDoListProvider.getToDoNotLoading();
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
                  child: UpdateToDoPage(toDoId: toDo.id),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onTapDelete(toDo.id),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => onTapDetail(toDo),
          ),
        ],
      ),
    );
  }
}
