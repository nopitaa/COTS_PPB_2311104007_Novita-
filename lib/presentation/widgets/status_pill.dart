import 'package:flutter/material.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';

class StatusPill extends StatelessWidget {
  final TaskStatus status;
  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    switch (status) {
      case TaskStatus.selesai:
        text = 'Selesai';
        break;
      case TaskStatus.terlambat:
        text = 'Terlambat';
        break;
      case TaskStatus.berjalan:
      default:
        text = 'Berjalan';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: AppTypography.muted.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
