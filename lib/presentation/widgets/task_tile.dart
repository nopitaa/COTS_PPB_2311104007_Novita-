import 'package:flutter/material.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';
import 'ds_card.dart';
import 'ds_chip.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskTile({super.key, required this.task, required this.onTap});

  String _fmt(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: DsCard(
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
                  const SizedBox(height: 6),
                  Text(
                    'Deadline: ${_fmt(task.deadline)}',
                    style: AppTypography.muted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              children: [
                DsStatusChip(status: task.status),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
