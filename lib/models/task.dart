enum TaskStatus { berjalan, selesai, terlambat }

TaskStatus taskStatusFromApi(String s) {
  switch (s.toUpperCase()) {
    case 'SELESAI':
      return TaskStatus.selesai;
    case 'TERLAMBAT':
      return TaskStatus.terlambat;
    default:
      return TaskStatus.berjalan;
  }
}

String taskStatusToApi(TaskStatus s) {
  switch (s) {
    case TaskStatus.selesai:
      return 'SELESAI';
    case TaskStatus.terlambat:
      return 'TERLAMBAT';
    case TaskStatus.berjalan:
    default:
      return 'BERJALAN';
  }
}

class Task {
  final int id;
  String title;
  String course;
  DateTime deadline;
  TaskStatus status;
  String note;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    required this.note,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      course: (json['course'] ?? '') as String,
      deadline: DateTime.parse(json['deadline'] as String),
      status: taskStatusFromApi((json['status'] ?? 'BERJALAN') as String),
      note: (json['note'] ?? '') as String,
      isDone: (json['is_done'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'course': course,
      'deadline': _dateOnly(deadline),
      'status': taskStatusToApi(status),
      'note': note,
      'is_done': isDone,
    };
  }

  Map<String, dynamic> toPatchJsonNoteOnly(String newNote) {
    return {'note': newNote};
  }

  Map<String, dynamic> toPatchJsonToggleDone(bool done, TaskStatus newStatus) {
    return {
      'is_done': done,
      'status': taskStatusToApi(newStatus),
    };
  }

  static String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
