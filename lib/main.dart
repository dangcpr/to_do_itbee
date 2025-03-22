import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'presentation/home/provider/theme_provider.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDb();
  await initLocalNoti();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder:
            (_, value, __) => MaterialApp.router(
              title: 'Flutter Demo',
              theme: value.isDark ? AppTheme.dark : AppTheme.light,
              darkTheme: value.isDark ? AppTheme.dark : AppTheme.light,
              debugShowCheckedModeBanner: false,
              routerConfig: goRouter,
            ),
      ),
    );
  }
}
