import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/models/internship.dart';
import 'package:job_app/widgets/app_button.dart';
import 'package:job_app/widgets/horoizontal_image_list.dart';
import 'package:job_app/widgets/tab_widget.dart';

class JobDetailsScreen extends StatefulWidget {
  const new({super.key, required this.internship});
  final Internship internship;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_border_rounded),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: HorizontalImageList(images: widget.internship.images),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      widget.internship.title,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(widget.internship.logoUrl, width: 40),
                        const SizedBox(width: 10),
                        Text(
                          widget.internship.company,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        Text(widget.internship.location),
                        Spacer(),

                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(widget.internship.duration),
                        Spacer(),

                        Container(
                          padding: .all(8),
                          decoration: BoxDecoration(
                            borderRadius: .circular(20),
                            color: Colors.greenAccent.shade100,
                          ),
                          child: Text(
                            widget.internship.type,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: AppColors.green,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: .symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              // Tabs
              Expanded(child: TabWidget(internship: widget.internship)),

              const SizedBox(height: 10),

              AppButton(title: 'Apply Now', onPressed: () {}),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
