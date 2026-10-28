import 'package:flutter/material.dart';

class HorizontalImageList extends StatelessWidget {
  const new({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: .only(
              topLeft: .circular(20),
              topRight: .circular(20),
            ),
            child: Stack(
              children: [
                Image.asset(images[index], fit: .cover, width: 400),
                Positioned(
                  bottom: 4,
                  right: 6,
                  child: Container(
                    padding: .all(8),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      "${index + 1}/${images.length}",
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
