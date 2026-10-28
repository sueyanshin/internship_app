import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_theme.dart';
import 'package:job_app/screens/main_screen.dart';
import 'package:job_app/screens/providers/bottom_nav_provider.dart';
import 'package:job_app/screens/providers/tab_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job App',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
