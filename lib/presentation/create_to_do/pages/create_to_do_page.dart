import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_itbee/core/extension.dart';

import '../../../core/button.dart';
import '../../../core/const.dart';
import '../../../core/function.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../../domain/usecases/to_do_usecase.dart';
import '../../../service_locator.dart';
import '../../home/provider/get_to_do_list_provider.dart';
import '../provider/create_to_do_provider.dart';

class CreateToDoPage extends StatefulWidget {
  const CreateToDoPage({super.key});

  @override
  State<CreateToDoPage> createState() => _CreateToDoPageState();
}

class _CreateToDoPageState extends State<CreateToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  Status status = Status.todo;

  String preTitle = '';
  String preDescription = '';

  Brightness get brightness => MediaQuery.of(context).platformBrightness;

  GetToDoListProvider getToDoListProvider = sl.get<GetToDoListProvider>();

  @override
  void initState() {
    super.initState();
    dueDateController.text = DateTime.now().toString();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateToDoProvider>(
      create: (_) => CreateToDoProvider(sl.get<ToDoUsecase>()),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: Text(
                      titleController.text == ''
                          ? 'Please fill in the title'
                          : titleController.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    subtitle: Text(
                      descriptionController.text == ''
                          ? 'Please fill in the description'
                          : descriptionController.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    trailing: InkWell(
                      child: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Edit Task Title'),
                                content: buildForm(),
                                actions: buildActions(),
                              ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Deadline'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Date'),
                      trailing: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.parse(
                                  dueDateController.text,
                                ).toLocal(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              dueDateController.text =
                                  dueDateController.text
                                      .toDateTime(isLocalTime: true)
                                      .copyWith(
                                        year: date.year,
                                        month: date.month,
                                        day: date.day,
                                      )
                                      .toString();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            DateTime.parse(dueDateController.text).formatDate(),
                            style: TextStyle(
                              color:
                                  brightness == Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ListTile(
                      leading: const Icon(Icons.timer),
                      title: const Text('Time'),
                      trailing: InkWell(
                        onTap: () async {
                          final date = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              DateTime.parse(dueDateController.text),
                            ),
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (date != null) {
                            setState(() {
                              DateTime dateTime = DateTime.parse(
                                dueDateController.text,
                              );

                              dateTime = dateTime.copyWith(
                                hour: date.hour,
                                minute: date.minute,
                                second: 0,
                              );

                              dueDateController.text = dateTime.toString();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            DateTime.parse(dueDateController.text).formatTime(
                              MediaQuery.of(context).alwaysUse24HourFormat,
                            ),
                            style: TextStyle(
                              color:
                                  brightness == Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        status = status.switchStatus();
                      });
                    },
                    leading:
                        status == Status.todo
                            ? const Icon(
                              Icons.radio_button_off,
                              color: Colors.red,
                            )
                            : const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                    title: const Text('Status'),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.nameStatus(),
                        style: TextStyle(
                          color:
                              brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<CreateToDoProvider>(
              builder:
                  (_, provider, __) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        provider.isLoading
                            ? AppButtons.circleButton()
                            : TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () async {
                                if (!checkValidation()) {
                                  return;
                                }

                                // due date when created is in UTC
                                final toDo = ToDoEntity(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dueDate: dueDateController.text.toDateTime(),
                                  status: status.index,
                                );

                                await provider.createToDo(toDo);

                                if (provider.errorMessage != '') {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    AppFunctions.snackMessage(
                                      context,
                                      provider.errorMessage,
                                    );
                                  });
                                  return;
                                }

                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  AppFunctions.snackMessage(
                                    context,
                                    "Task created successfully",
                                  );
                                });
                                await getToDoListProvider
                                    .getToDoListStatusSearchCurrent();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Title'),
          controller: titleController,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Description'),
          controller: descriptionController,
        ),
      ],
    );
  }

  List<Widget> buildActions() {
    return [
      TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          titleController.text = preTitle;
          descriptionController.text = preDescription;
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: const Text('Save'),
        onPressed: () {
          setState(() {});
          titleController.text = titleController.text.trim();
          preTitle = titleController.text;

          descriptionController.text = descriptionController.text.trim();
          preDescription = descriptionController.text;

          Navigator.pop(context);
        },
      ),
    ];
  }

  bool checkValidation() {
    if (titleController.text.isEmpty) {
      AppFunctions.snackMessage(context, 'Please enter title');
      return false;
    }

    if (descriptionController.text.isEmpty) {
      AppFunctions.snackMessage(context, 'Please enter description');
      return false;
    }

    if (dueDateController.text.isEmpty) {
      AppFunctions.snackMessage(context, 'Please enter due date');
      return false;
    }

    if (dueDateController.text.toDateTime().isBefore(DateTime.now())) {
      AppFunctions.snackMessage(context, 'Please enter future date');
      return false;
    }

    return true;
  }
}
