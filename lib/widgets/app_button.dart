import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    this.iconData,
    this.backgroundColor = AppColors.primaryLight,
    this.color = AppColors.surface,
    required this.onPressed,
  });

  final String title;
  final IconData? iconData;
  final Color backgroundColor;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: .all(14),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      ),
      child: Text(
        title,
        style: theme.textTheme.labelLarge!.copyWith(
          color: color,
          fontWeight: .bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
