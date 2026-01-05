import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_routes.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';
import '../widgets/task_tile.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchC = TextEditingController();
  TaskStatus? _tab; // null = semua

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskController>().loadAll());
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  bool _isOverdue(Task t) {
    if (t.isDone) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(t.deadline.year, t.deadline.month, t.deadline.day);
    return due.isBefore(today);
  }

  List<Task> _applyFilter(List<Task> tasks) {
    // ✅ buat list growable agar boleh sort
    List<Task> out = tasks.toList(growable: true);

    if (_tab == TaskStatus.selesai) {
      out = out.where((t) => t.isDone).toList(growable: true);
    } else if (_tab == TaskStatus.terlambat) {
      out = out.where(_isOverdue).toList(growable: true);
    } else if (_tab == TaskStatus.berjalan) {
      out = out
          .where((t) => !t.isDone && !_isOverdue(t))
          .toList(growable: true);
    }

    final q = _searchC.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.course.toLowerCase().contains(q),
          )
          .toList(growable: true);
    }

    // ✅ SORT aman
    out.sort((a, b) => a.deadline.compareTo(b.deadline));
    return out;
  }

  Widget _chip(String text, TaskStatus? value) {
    final selected = _tab == value;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _tab = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check, size: 16),
              const SizedBox(width: 6),
            ],
            Text(text, style: AppTypography.body),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TaskController>();
    final tasks = _applyFilter(c.tasks);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Daftar Tugas',
          style: AppTypography.subtitle.copyWith(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.form);
              if (mounted) context.read<TaskController>().loadAll();
            },
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
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari tugas atau mata kuliah...',
                hintStyle: AppTypography.muted,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip('Semua', null),
                  const SizedBox(width: 8),
                  _chip('Berjalan', TaskStatus.berjalan),
                  const SizedBox(width: 8),
                  _chip('Selesai', TaskStatus.selesai),
                  const SizedBox(width: 8),
                  _chip('Terlambat', TaskStatus.terlambat),
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (c.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (c.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    c.error!,
                    style: AppTypography.muted.copyWith(
                      color: AppColors.danger,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (tasks.isEmpty)
              Expanded(
                child: Center(
                  child: Text('Tidak ada data.', style: AppTypography.muted),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    final t = tasks[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: TaskTile(
                        task: t,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.detail,
                          arguments: t.id,
                        ),
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
}
