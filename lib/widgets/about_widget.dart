import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/models/internship.dart';

class AboutWidget extends StatelessWidget {
  const new({super.key, required this.internship});
  final Internship internship;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (internship.description.isNotEmpty) ...[
            Text(
              'Job Description',
              style: theme.textTheme.titleSmall!.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 10),
            Text(
              internship.description,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (internship.responsibilities.isNotEmpty) ...[
            Text(
              'Key Responsibilities',
              style: theme.textTheme.titleSmall!.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: internship.responsibilities.length,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(Icons.check, size: 20, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        internship.responsibilities[index],
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
          ],
          if (internship.requirements.isNotEmpty) ...[
            Text(
              'Key Requirements',
              style: theme.textTheme.titleSmall!.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: internship.responsibilities.length,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: .center,
                  children: [
                    Icon(Icons.circle, size: 10, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        internship.requirements[index],
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
