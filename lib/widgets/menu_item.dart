import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: .circular(20),
              ),
              child: Icon(icon, size: 35, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
