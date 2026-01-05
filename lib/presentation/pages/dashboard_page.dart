import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_routes.dart';
import '../../../controllers/task_controller.dart';
import '../../../design_system/app_spacing.dart';
import '../../../design_system/app_typography.dart';
import '../widgets/ds_card.dart';
import '../widgets/task_tile.dart';
import '../widgets/ds_button.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Besar', style: AppTypography.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.list),
            child: const Text('Daftar Tugas'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Tugas', style: AppTypography.muted),
                        const SizedBox(height: 6),
                        Text('${c.totalCount}', style: AppTypography.title),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selesai', style: AppTypography.muted),
                        const SizedBox(height: 6),
                        Text('${c.doneCount}', style: AppTypography.title),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tugas Terdekat', style: AppTypography.subtitle),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...c.nearestTasks.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TaskTile(
                    task: t,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: t.id,
                    ),
                  ),
                )),
            const Spacer(),
            DsButton(
              text: 'Tambah Tugas',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.form),
            ),
          ],
        ),
      ),
    );
  }
}
