import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/data/mock_data.dart';
import 'package:job_app/models/timeline_step.dart';
import 'package:job_app/widgets/application_card.dart';
import 'package:job_app/widgets/course_card.dart';
import 'package:job_app/widgets/progress_card.dart';
import 'package:job_app/widgets/title_see_all_widget.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Progress'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [ProgressCard(), const SizedBox(height: 20)],
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isLast = index == steps.length - 1;
                    return _buildStepItem(context, step, isLast);
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: .only(left: 48),
                    child: const Divider(height: 1, thickness: 1),
                  ),
                  itemCount: steps.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TitleSeeAllWidget(title: 'My Applications', onPressed: () {}),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      ApplicationCard(
                        total: 5,
                        label: 'Applied',
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.blue.shade100,
                      ),
                      ApplicationCard(
                        total: 2,
                        label: 'In Review',
                        foregroundColor: Colors.orange,
                        backgroundColor: Colors.orange.shade100,
                      ),
                      ApplicationCard(
                        total: 1,
                        label: 'Interview',
                        foregroundColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TitleSeeAllWidget(
                    title: 'Suggested Learning',
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return CourseCard(course: courses[index]);
              }, childCount: courses.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildStepItem(BuildContext context, TimelineStep step, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        children: [
          Column(
            mainAxisAlignment: .center,
            children: [
              _buildStepIcon(step.state),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 4,
                    height: 8,
                    margin: .symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: .circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: .w600,
                    color: step.state == TimelineStepState.upcoming
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                if (step.state != TimelineStepState.done)
                  Text(
                    step.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: .w500,
                      color: _getSubtitleColor(step.state),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          if (step.state == TimelineStepState.done)
            Text(
              step.subtitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: .w500,
                color: _getSubtitleColor(step.state),
              ),
            ),

          if (step.state == TimelineStepState.upcoming)
            Icon(Icons.lock, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildStepIcon(TimelineStepState state) {
    switch (state) {
      case TimelineStepState.done:
        return const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.green,
          child: Icon(Icons.check, color: Colors.white, size: 20),
        );

      case TimelineStepState.active:
        return const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.circle, color: Colors.white, size: 10),
        );
      case TimelineStepState.upcoming:
        return Stack(
          alignment: .center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: .circle, color: AppColors.muted),
            ),
            Positioned(
              top: -1,
              child: Column(
                children: [
                  Container(
                    width: 6,
                    height: 10,
                    alignment: .bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: .rectangle,
                      borderRadius: .only(
                        topLeft: .circular(10),
                        topRight: .circular(10),
                      ),
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Color _getSubtitleColor(TimelineStepState state) {
    switch (state) {
      case TimelineStepState.done:
        return AppColors.green;
      case TimelineStepState.active:
        return AppColors.blue;
      case TimelineStepState.upcoming:
        return AppColors.textSecondary;
    }
  }
}
