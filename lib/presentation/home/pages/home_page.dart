import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../core/const.dart';
import '../../../service_locator.dart';
import '../../create_to_do/pages/create_to_do_page.dart';
import '../provider/get_to_do_list_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/empty_widget.dart';
import '../widgets/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Status status;
  TextEditingController searchController = TextEditingController();

  final getToDoListProvider = sl.get<GetToDoListProvider>();

  @override
  void initState() {
    super.initState();
    status = Status.all;
    getToDoListProvider.getToDoList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetToDoListProvider>(
      create: (_) => getToDoListProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            Icon(Icons.sunny),
            Switch(
              value: context.watch<ThemeProvider>().isDark,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
            Icon(Icons.nightlight_round),
            SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: InkWell(
                    child: Icon(Icons.clear),
                    onTap: () async {
                      searchController.clear();
                      getToDoListProvider.getToDoList(status: status);
                    },
                  ),
                ),
                onTapOutside:
                    (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (value) async {
                  await getToDoListProvider.getToDoList(
                    status: status,
                    searchPattern: searchController.text,
                  );
                },
              ),
              const SizedBox(height: 16),
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
                      await getToDoListProvider.getToDoList(
                        searchPattern: searchController.text,
                      );
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
                        searchPattern: searchController.text,
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
                        searchPattern: searchController.text,
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
                    return Expanded(
                      child: SingleChildScrollView(
                        child: EmptyWidget(status: status),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: value.toDoList.length,
                      itemBuilder: (context, index) {
                        final toDo = value.toDoList[index];
                        return TaskWidget(
                          toDo: toDo,
                          getToDoListProvider: getToDoListProvider,
                        );
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
}
