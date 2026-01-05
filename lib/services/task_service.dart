import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/supabase_config.dart';
import '../models/task.dart';

class TaskService {
  static const _table = 'tasks';

  Uri _uri(String pathAndQuery) => Uri.parse('${SupabaseConfig.baseUrl}$pathAndQuery');

  Map<String, String> get _headers => {
        'apikey': SupabaseConfig.anonKey,
        'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
        'Content-Type': 'application/json',
      };

  String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // GET semua / filter status
  Future<List<Task>> fetchTasks({TaskStatus? status}) async {
    final qs = status == null
        ? '/rest/v1/$_table?select=*'
        : '/rest/v1/$_table?select=*&status=eq.${taskStatusToApi(status)}';

    final res = await http.get(_uri(qs), headers: _headers);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Fetch tasks gagal: ${res.statusCode} ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  // POST tambah task
  Future<Task> addTask({
    required String title,
    required String course,
    required DateTime deadline,
    required TaskStatus status,
    required String note,
    required bool isDone,
  }) async {
    final body = jsonEncode({
      'title': title,
      'course': course,
      'deadline': _dateOnly(deadline), // ✅ FIX
      'status': taskStatusToApi(status),
      'note': note,
      'is_done': isDone,
    });

    final res = await http.post(
      _uri('/rest/v1/$_table'),
      headers: {
        ..._headers,
        'Prefer': 'return=representation',
      },
      body: body,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Add task gagal: ${res.statusCode} ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;
    return Task.fromJson(data.first as Map<String, dynamic>);
  }

  // PATCH update note
  Future<Task> updateNote({required int id, required String note}) async {
    final res = await http.patch(
      _uri('/rest/v1/$_table?id=eq.$id'),
      headers: {
        ..._headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode({'note': note}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update note gagal: ${res.statusCode} ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;
    return Task.fromJson(data.first as Map<String, dynamic>);
  }

  // PATCH toggle selesai/berjalan/terlambat
  Future<Task> updateDoneAndStatus({
    required int id,
    required bool isDone,
    required TaskStatus status,
  }) async {
    final res = await http.patch(
      _uri('/rest/v1/$_table?id=eq.$id'),
      headers: {
        ..._headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode({
        'is_done': isDone,
        'status': taskStatusToApi(status),
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update status gagal: ${res.statusCode} ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;
    return Task.fromJson(data.first as Map<String, dynamic>);
  }
}
