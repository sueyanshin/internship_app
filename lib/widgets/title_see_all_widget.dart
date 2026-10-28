import 'package:flutter/material.dart';

class TitleSeeAllWidget extends StatelessWidget {
  const new({super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'See All',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.blue[900],
            ),
          ),
        ),
      ],
    );
  }
}
