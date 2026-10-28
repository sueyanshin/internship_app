import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';

class BannerCard extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.description,
    required this.onButtonTap,
    this.buttonLabel,
    this.bannerImage,
  });

  final String title;
  final String description;
  final VoidCallback onButtonTap;
  final String? bannerImage;
  final String? buttonLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        image: DecorationImage(
          image: AssetImage(bannerImage ?? 'assets/images/explore-banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          spacing: 4,
          mainAxisAlignment: .center,
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
            Text(
              description,
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: .symmetric(horizontal: 16),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              ),
              onPressed: onButtonTap,
              child: Text(
                buttonLabel ?? 'Explore Now →',
                style: theme.textTheme.titleSmall!.copyWith(
                  color: AppColors.primary,
                  fontWeight: .w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
