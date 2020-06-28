class Task {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime lastEdit;

  Task(
      {this.description,
      this.id,
      this.isDone = false,
      this.title,
      this.lastEdit});
}
