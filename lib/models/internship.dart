class Internship {
  final String title;
  final String company;
  final String location;
  final String duration;
  final String type;
  final String logoUrl;
  final List<String> images;
  final String description;
  final List<String> responsibilities;
  final List<String> requirements;
  final String postedAt;

  new({
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.type,
    required this.logoUrl,
    required this.images,
    required this.description,
    required this.responsibilities,
    required this.requirements,
    required this.postedAt,
  });
}

class Course {
  final String title;
  final String company;
  final String duration;
  final String level;
  final String imageUrl;

  new({
    required this.title,
    required this.company,
    required this.duration,
    required this.level,
    required this.imageUrl,
  });
}
