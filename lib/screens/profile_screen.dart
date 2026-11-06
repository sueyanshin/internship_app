import 'package:flutter/material.dart';
import 'package:job_app/screens/login_screen.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/screens/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = userProvider.currentUser;
            if (user == null) {
              return Text('No profile data found');
            }
            return Center(
              child: Column(
                spacing: 6,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: .all(40),
                    color: theme.colorScheme.primary,
                    child: CircleAvatar(
                      radius: 40,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(user.name, style: theme.textTheme.titleLarge),
                  Text(user.phone, style: theme.textTheme.bodyMedium),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      authProvider.signOut();
                      userProvider.clearUser();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.logout),

                    label: Text('Sign out'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
