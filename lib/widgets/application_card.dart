import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';

class ApplicationCard extends StatelessWidget {
  const new({
    super.key,
    required this.total,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final int total;
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(30),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Text(
            total.toString(),
            style: theme.textTheme.titleLarge!.copyWith(color: foregroundColor),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium!.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
