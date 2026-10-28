import 'package:flutter/material.dart';
import 'package:job_app/data/mock_data.dart';
import 'package:job_app/models/skill_tag_data.dart';
import 'package:job_app/screens/job_details_screen.dart';
import 'package:job_app/screens/profile_screen.dart';
import 'package:job_app/widgets/banner_card.dart';
import 'package:job_app/widgets/header_section.dart';
import 'package:job_app/widgets/job_card.dart';
import 'package:job_app/widgets/menu_item.dart';
import 'package:job_app/widgets/skill_widget.dart';
import 'package:job_app/widgets/title_see_all_widget.dart';

class HomeScreen extends StatelessWidget {
  new({super.key});

  final List<SkillTagData> tags = [
    SkillTagData(
      label: 'Flutter',
      textColor: Colors.lightBlue.shade800,
      backgroundColor: Colors.lightBlue.shade100,
    ),
    SkillTagData(
      label: 'Dart',
      textColor: Colors.blue.shade800,
      backgroundColor: Colors.blue.shade100,
    ),
    SkillTagData(
      label: 'UI/UX',
      textColor: Colors.green.shade800,
      backgroundColor: Colors.green.shade100,
    ),
    SkillTagData(
      label: 'Git',
      textColor: Colors.deepOrange.shade800,
      backgroundColor: Colors.deepOrange.shade100,
    ),
    SkillTagData(
      label: 'Python',
      textColor: Colors.pink.shade800,
      backgroundColor: Colors.pink.shade100,
    ),
    SkillTagData(
      label: 'Firebase',
      textColor: Colors.amber.shade800,
      backgroundColor: Colors.amber.shade100,
    ),
    SkillTagData(
      label: 'Figma',
      textColor: Colors.indigo.shade800,
      backgroundColor: Colors.indigo.shade100,
    ),
  ];

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
                    HeaderSection(
                      username: "Thike Thike",
                      profileImage: "assets/images/profile-image.jpg",
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
                                builder: (context) => ProfileScreen(),
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
