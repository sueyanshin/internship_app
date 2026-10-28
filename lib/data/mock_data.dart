import 'package:job_app/models/internship.dart';
import 'package:job_app/models/timeline_step.dart';

List<Internship> internships = [
  Internship(
    title: 'Mobile App Developer Intern',
    company: 'Google',
    location: 'Remote',
    duration: '3–6 months',
    type: 'Internship',
    logoUrl: 'assets/images/google-logo.jpg',
    images: ['assets/images/office2.jpg', 'assets/images/office3.jpg'],
    description:
        'Join our mobile team to build and improve Android '
        'and iOS applications. Work with experienced engineers '
        'and make real impact for millions of users.',
    responsibilities: [
      'Develop and maintain Flutter mobile applications',
      'Collaborate with cross-functional teams',
      'Participate in code reviews',
      'Learn and apply best practices',
    ],
    requirements: [
      'Currently enrolled in a university program',
      'Basic knowledge of Flutter or Android/iOS',
      'Good problem-solving skills',
      'Passionate about mobile development',
    ],
    postedAt: '3 days ago',
  ),
  Internship(
    title: 'Flutter Developer Intern',
    company: 'Tech Solutions',
    location: 'Yangon, Myanmar',
    duration: '3 months',
    type: 'Internship',
    logoUrl: 'assets/images/flutter-logo.png',
    images: [],
    description: '',
    responsibilities: [],
    requirements: [],
    postedAt: '5 days ago',
  ),
  Internship(
    title: 'UI/UX Design Intern',
    company: 'Creative Studio',
    location: 'Remote',
    duration: '3 months',
    type: 'Internship',
    logoUrl: 'assets/images/figma-logo.png',
    images: [],
    description: '',
    responsibilities: [],
    requirements: [],
    postedAt: '1 week ago',
  ),
];

final List<String> skills = [
  'Flutter',
  'Dart',
  'UI/UX',
  'Git',
  'Python',
  'Firebase',
  'REST API',
  'Figma',
];

List<Course> courses = [
  Course(
    title: 'Flutter for beginners',
    company: 'Google Developers',
    duration: '2.5 hours',
    level: 'Beginner',
    imageUrl: 'assets/images/flutter-course.png',
  ),
  Course(
    title: 'UI/UX Design Fundamental',
    company: 'Coursera',
    duration: '3 hours',
    level: 'Beginner',
    imageUrl: 'assets/images/figma-logo.png',
  ),
];

List<TimelineStep> steps = [
  TimelineStep(
    title: 'Complete profile',
    subtitle: 'Done',
    state: TimelineStepState.done,
  ),
  TimelineStep(
    title: 'Build your resume',
    subtitle: 'Done',
    state: TimelineStepState.done,
  ),
  TimelineStep(
    title: 'Apply for internship',
    subtitle: "You're here",
    state: TimelineStepState.active,
  ),
  TimelineStep(
    title: 'Attend interviews',
    subtitle: 'Upcoming',
    state: TimelineStepState.upcoming,
  ),
  TimelineStep(
    title: 'Get Hired 🎉',
    subtitle: 'Upcoming',
    state: TimelineStepState.upcoming,
  ),
];
