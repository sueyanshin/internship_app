import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/models/internship.dart';

class CourseCard extends StatelessWidget {
  const new({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .symmetric(horizontal: 12, vertical: 20),
      margin: .only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(12),
      ),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .spaceBetween,
        children: [
          ClipRRect(
            borderRadius: .circular(12),
            child: Image.asset(
              course.imageUrl,
              fit: .cover,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(course.title, style: theme.textTheme.titleMedium),
                Text(course.company, style: theme.textTheme.bodyMedium),
                Text(
                  '${course.duration}⋅ ${course.level}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.play_circle_fill,
              color: AppColors.primary,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
