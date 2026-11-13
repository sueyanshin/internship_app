import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_app/screens/profile/edit_profile_screen.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
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
      context.read<AppAuthProvider>().fetchUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<AppAuthProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = provider.userProfile;
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
                    padding: .all(50),
                    color: theme.colorScheme.primary,
                    child: CircleAvatar(
                      radius: 40,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profileUrl ?? "",
                          width: 100,
                          height: 100,
                          fit: .cover,
                          httpHeaders: const {"User-Agent": "Mozilla/5.0"},
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            debugPrint("Image load error: $error");
                            return const Icon(Icons.person, size: 40);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(user.name, style: theme.textTheme.titleLarge),
                  user.phone.isNotEmpty
                      ? Text(user.phone, style: theme.textTheme.bodyMedium)
                      : SizedBox.shrink(),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      provider.signOut();
                      provider.clearUser();
                      if (context.mounted) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
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
