class TimelineStep {
  final String title;
  final String subtitle;
  final TimelineStepState state;

  new({required this.title, required this.subtitle, required this.state});
}

enum TimelineStepState { done, active, upcoming }
