import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService service;

  TaskController(this.service);

  final List<Task> _tasks = [];
  bool _loading = false;
  String? _error;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get loading => _loading;
  String? get error => _error;

  Task? findById(int id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // rule terlambat: belum selesai & deadline < hari ini
  TaskStatus _computeStatus({required bool isDone, required DateTime deadline}) {
    if (isDone) return TaskStatus.selesai;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);

    if (due.isBefore(today)) return TaskStatus.terlambat;
    return TaskStatus.berjalan;
  }

  Future<void> loadAll() async {
    _setLoading(true);
    _error = null;
    try {
      final data = await service.fetchTasks();
      _tasks
        ..clear()
        ..addAll(data);

      // refresh overdue lokal (biar status sesuai rule)
      for (final t in _tasks) {
        final computed = _computeStatus(isDone: t.isDone, deadline: t.deadline);
        // kalau API belum update TERLAMBAT, UI tetap benar
        t.status = t.isDone ? TaskStatus.selesai : computed;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTaskRemote({
    required String title,
    required String course,
    required DateTime deadline,
    required bool isDone,
    required String note,
  }) async {
    final status = _computeStatus(isDone: isDone, deadline: deadline);
    _setLoading(true);
    _error = null;
    try {
      final created = await service.addTask(
        title: title,
        course: course,
        deadline: deadline,
        status: status,
        note: note,
        isDone: isDone,
      );
      _tasks.insert(0, created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateNoteRemote(int id, String note) async {
    _setLoading(true);
    _error = null;
    try {
      final updated = await service.updateNote(id: id, note: note);
      final idx = _tasks.indexWhere((t) => t.id == id);
      if (idx != -1) _tasks[idx] = updated;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleDoneRemote(int id, bool done) async {
    final t = findById(id);
    if (t == null) return;

    final newStatus = _computeStatus(isDone: done, deadline: t.deadline);

    _setLoading(true);
    _error = null;
    try {
      final updated = await service.updateDoneAndStatus(
        id: id,
        isDone: done,
        status: newStatus,
      );
      final idx = _tasks.indexWhere((x) => x.id == id);
      if (idx != -1) _tasks[idx] = updated;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
