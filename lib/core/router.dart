import 'package:go_router/go_router.dart';

import '../presentation/create_to_do/pages/create_to_do_page.dart';
import '../presentation/home/pages/home_page.dart';
import '../presentation/update_to_do/pages/update_to_do_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateToDoPage(),
    ),
    GoRoute(
      path: '/update/:id',
      name: 'update',
      redirect: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final idInt = int.tryParse(id);
        if (idInt == null) {
          return '/create';
        }
        return null;
      },
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final idInt = int.tryParse(id);
        if (idInt != null) {
          return UpdateToDoPage(toDoId: idInt);
        }
        return const CreateToDoPage();
      },
    ),
  ],
);
