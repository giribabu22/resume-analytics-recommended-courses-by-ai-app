import 'package:abhyas/features/app/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'features/user_auth/presentation/pages/login.dart';




Future main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'abhyas',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(
        child:  LoginPage(),
      )
    );
  }
}
