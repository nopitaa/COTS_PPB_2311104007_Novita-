import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';

class DsStatusChip extends StatelessWidget {
  final TaskStatus status;
  const DsStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final done = status == TaskStatus.selesai;
    final fg = done ? AppColors.success : AppColors.primary;
    final bg = fg.withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Text(
        done ? 'Selesai' : 'Berjalan',
        style: AppTypography.muted.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
