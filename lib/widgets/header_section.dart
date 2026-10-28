import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  const new({super.key, required this.username, required this.profileImage});
  final String username;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Column(
          crossAxisAlignment: .start,
          children: [
            Text('Hello,', style: theme.textTheme.labelLarge),
            Text('$username 👋', style: theme.textTheme.titleLarge),
            Text(
              "Let's build your future together!",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                profileImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
