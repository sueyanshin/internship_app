import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:job_app/core/theme/app_theme.dart';
import 'package:job_app/firebase_options.dart';
import 'package:job_app/screens/auth/login_screen.dart';
import 'package:job_app/screens/main_screen.dart';
import 'package:job_app/screens/providers/bottom_nav_provider.dart';
import 'package:job_app/screens/providers/tab_provider.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/screens/auth/upload_profile_image_screen.dart';
import 'package:job_app/service/auth_service.dart';
import 'package:job_app/service/drive_storage_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final driveStorageService = DriveStorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider(
            AuthService(FirebaseAuth.instance, FirebaseFirestore.instance),
            driveStorageService,
          ),
        ),
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
      home: Consumer<AppAuthProvider>(
        builder: (context, provider, child) {
          debugPrint('ROUTING CHECK');
          debugPrint('UID: ${provider.firebaseUser?.uid}');
          debugPrint('Needs Setup: ${provider.needsProfileSetup}');
          debugPrint(
            'SCREEN: ${provider.firebaseUser == null
                ? "LoginScreen"
                : provider.needsProfileSetup
                ? "UploadProfileImageScreen"
                : "MainScreen"}',
          );
          // firebase auth check
          if (!provider.isAuthInitialized || provider.isProfileLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          // Not Log in
          if (provider.firebaseUser == null) {
            return LoginScreen();
          }
          // upload profile image requried
          if (provider.needsProfileSetup) {
            return UploadProfileImageScreen();
          }

          return MainScreen();
        },
      ),
    );
  }
}
