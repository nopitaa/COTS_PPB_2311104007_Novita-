enum TaskStatus { berjalan, selesai, terlambat }

class Task {
  final String id;
  String title;
  String course;
  DateTime deadline;
  TaskStatus status;
  String note;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    this.status = TaskStatus.berjalan,
    this.note = '',
  });
}
