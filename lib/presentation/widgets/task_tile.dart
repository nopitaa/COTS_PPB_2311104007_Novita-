import 'package:flutter/material.dart';

import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';
import 'ds_card.dart';
import 'status_pill.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
  });

  bool _isOverdue(Task t) {
    if (t.isDone) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(t.deadline.year, t.deadline.month, t.deadline.day);
    return due.isBefore(today);
  }

  TaskStatus _statusForUi(Task t) {
    if (t.isDone) return TaskStatus.selesai;
    if (_isOverdue(t)) return TaskStatus.terlambat;
    return TaskStatus.berjalan;
  }

  String _fmtDate(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final uiStatus = _statusForUi(task);

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      onTap: onTap,
      child: DsCard(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: AppTypography.subtitle),
                    const SizedBox(height: 4),
                    Text(task.course, style: AppTypography.muted),
                    const SizedBox(height: 8),
                    Text('Deadline: ${_fmtDate(task.deadline)}', style: AppTypography.muted),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusPill(status: uiStatus),
                  const SizedBox(height: 18),
                  const Icon(Icons.chevron_right),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
