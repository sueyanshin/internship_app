import 'package:flutter/material.dart';
import 'package:job_app/data/mock_data.dart';
import 'package:job_app/screens/job_details_screen.dart';
import 'package:job_app/screens/my_progress_screen.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/widgets/banner_card.dart';
import 'package:job_app/widgets/header_section.dart';
import 'package:job_app/widgets/job_card.dart';
import 'package:job_app/widgets/menu_item.dart';
import 'package:job_app/widgets/skill_widget.dart';
import 'package:job_app/widgets/title_see_all_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppAuthProvider>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Header Section
                    Consumer<AppAuthProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final user = provider.userProfile;
                        if (user == null) {
                          return Text("Please login to your account");
                        }
                        return HeaderSection(
                          username: user.name,
                          profileImage: user.profileUrl!,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // Banner Card
                    BannerCard(
                      title: 'Find your\nDream Internship',
                      description:
                          'Gain real experience\n and grow your skills',
                      onButtonTap: () {},
                    ),
                    SizedBox(height: 20),
                    // Menu Items
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        MenuItem(
                          title: 'Internship',
                          backgroundColor: Colors.blue[200]!,
                          iconColor: Colors.blue[600]!,
                          icon: Icons.work_rounded,
                          onTap: () {},
                        ),
                        MenuItem(
                          title: 'Companies',
                          backgroundColor: Colors.purple[200]!,
                          iconColor: Colors.purple[600]!,
                          icon: Icons.apartment_rounded,
                          onTap: () {},
                        ),
                        MenuItem(
                          title: 'Learning',
                          backgroundColor: Colors.red[200]!,
                          iconColor: Colors.red[600]!,
                          icon: Icons.menu_book_rounded,
                          onTap: () {},
                        ),
                        MenuItem(
                          title: 'My Progress',
                          backgroundColor: Colors.green[200]!,
                          iconColor: Colors.green[600]!,
                          icon: Icons.bar_chart_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProgressScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    TitleSeeAllWidget(
                      title: "Recommended for You",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                    left: 16,
                    right: 16,
                  ),
                  child: JobCard(
                    internship: internships[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              JobDetailsScreen(internship: internships[index]),
                        ),
                      );
                    },
                  ),
                );
              }, childCount: internships.length),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TitleSeeAllWidget(
                      title: "Popular Skills",
                      onPressed: () {},
                    ),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: tags.map((tag) {
                        return SkillTagWidget(tag: tag);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
