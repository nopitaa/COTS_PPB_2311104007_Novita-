import '../models/task.dart';

class TaskService {
  List<Task> seed() {
    return [
      Task(
        id: '1',
        title: 'Perancangan MVC + Services',
        course: 'Pemrograman Lanjut',
        deadline: DateTime(2026, 1, 18),
        status: TaskStatus.berjalan,
        note: 'Pisahkan Controller, Service, dan Config untuk konsumsi API.',
      ),
      Task(
        id: '2',
        title: 'Integrasi Consume API',
        course: 'Rekayasa Perangkat Lunak',
        deadline: DateTime(2026, 1, 15),
        status: TaskStatus.berjalan,
      ),
      Task(
        id: '3',
        title: 'Revisi Proposal',
        course: 'Metodologi Penelitian',
        deadline: DateTime(2026, 1, 10),
        status: TaskStatus.selesai,
      ),
      Task(
        id: '4',
        title: 'Dokumentasi Endpoint',
        course: 'Pemrograman Lanjut',
        deadline: DateTime(2026, 1, 16),
        status: TaskStatus.berjalan,
      ),
    ];
  }
}
