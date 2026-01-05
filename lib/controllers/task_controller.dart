import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _service;
  late List<Task> _tasks;

  TaskController(this._service) {
    _tasks = _service.seed();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get totalCount => _tasks.length;
  int get doneCount => _tasks.where((t) => t.status == TaskStatus.selesai).length;

  List<Task> get nearestTasks {
    final copy = [..._tasks];
    copy.sort((a, b) => a.deadline.compareTo(b.deadline));
    return copy.take(3).toList();
  }

  Task? findById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // STATE WAJIB: tambah tugas
  void addTask(Task task) {
    _tasks = [task, ..._tasks];
    notifyListeners();
  }

  // STATE WAJIB: ubah status/detail
  void toggleStatus(String id, bool done) {
    final t = findById(id);
    if (t == null) return;
    t.status = done ? TaskStatus.selesai : TaskStatus.berjalan;
    notifyListeners();
  }

  void updateNote(String id, String note) {
    final t = findById(id);
    if (t == null) return;
    t.note = note;
    notifyListeners();
  }
}
