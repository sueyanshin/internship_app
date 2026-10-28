import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';

class ProgressCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          ProgressCircle(progress: 0.7),
          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Your Internship Journey',
                  style: theme.textTheme.titleMedium!.copyWith(fontSize: 16),
                ),
                Text(
                  'Keep going! You\'re making great progress',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCircle extends StatelessWidget {
  const new({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 70,
      width: 70,

      child: Stack(
        alignment: .center,
        children: [
          const SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation(AppColors.bluePastel),
            ),
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(AppColors.green),
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: .bold,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
