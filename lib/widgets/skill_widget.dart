import 'package:flutter/material.dart';
import 'package:job_app/models/skill_tag_data.dart';

class SkillTagWidget extends StatelessWidget {
  const new({super.key, required this.tag});

  final SkillTagData tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: tag.backgroundColor,
        borderRadius: .circular(12.0),
      ),
      child: Text(
        tag.label,
        style: theme.textTheme.labelLarge!.copyWith(color: tag.textColor),
      ),
    );
  }
}
