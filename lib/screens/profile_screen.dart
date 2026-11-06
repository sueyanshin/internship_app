import 'package:flutter/material.dart';
import 'package:job_app/screens/login_screen.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Email: ${authProvider.user!.email.toString()}"),
              TextButton(
                onPressed: () {
                  authProvider.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },

                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
