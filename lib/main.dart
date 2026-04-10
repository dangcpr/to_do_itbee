import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_itbee/firebase_options.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'domain/usecases/auth_usecase.dart';
import 'presentation/home/provider/theme_provider.dart';
import 'presentation/sign_in/provider/user_provider.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDb();
  await initFirebase();
  await initLocalNoti();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(sl.get<AuthUsecase>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder:
            (_, value, _) => MaterialApp.router(
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
