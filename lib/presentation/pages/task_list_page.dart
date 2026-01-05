import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_routes.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';
import '../widgets/task_tile.dart';

enum TaskFilter { semua, berjalan, selesai, terlambat }

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchC = TextEditingController();
  TaskFilter _filter = TaskFilter.semua;

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TaskController>();
    final now = DateTime.now();
    final q = _searchC.text.trim().toLowerCase();

    final filtered = c.tasks.where((t) {
      final matchSearch = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          t.course.toLowerCase().contains(q);

      bool matchFilter = true;
      switch (_filter) {
        case TaskFilter.semua:
          matchFilter = true;
          break;
        case TaskFilter.berjalan:
          matchFilter = t.status == TaskStatus.berjalan;
          break;
        case TaskFilter.selesai:
          matchFilter = t.status == TaskStatus.selesai;
          break;
        case TaskFilter.terlambat:
          matchFilter = t.status != TaskStatus.selesai && t.deadline.isBefore(now);
          break;
      }
      return matchSearch && matchFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tugas', style: AppTypography.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.form),
            child: const Text('Tambah'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(
              controller: _searchC,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari tugas atau mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip('Semua', TaskFilter.semua),
                  _chip('Berjalan', TaskFilter.berjalan),
                  _chip('Selesai', TaskFilter.selesai),
                  _chip('Terlambat', TaskFilter.terlambat),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final t = filtered[i];
                  return TaskTile(
                    task: t,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: t.id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, TaskFilter value) {
    final selected = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = value),
      ),
    );
  }
}
