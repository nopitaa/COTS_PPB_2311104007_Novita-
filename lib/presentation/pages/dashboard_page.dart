import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_routes.dart';
import '../../../controllers/task_controller.dart';
import '../../../design_system/app_colors.dart';
import '../../../design_system/app_spacing.dart';
import '../../../design_system/app_typography.dart';
import '../../../models/task.dart';
import '../widgets/ds_button.dart';
import '../widgets/ds_card.dart';
import '../widgets/task_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskController>().loadAll());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TaskController>();

    final total = c.tasks.length;
    final selesai = c.tasks.where((t) => t.isDone).length;

    // ✅ buat list yang bisa di-sort
    final nearest = c.tasks
        .where((t) => !t.isDone)
        .toList(growable: true)
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    final nearestTop = nearest.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text('Tugas Besar', style: AppTypography.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.list),
            child: const Text('Daftar Tugas'),
          ),
        ],
      ),

      // ✅ tombol bawah FIX
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, AppSpacing.md),
          child: DsButton(
            text: 'Tambah Tugas',
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.form);
              if (mounted) context.read<TaskController>().loadAll();
            },
          ),
        ),
      ),

      // ✅ body scrollable (anti overflow)
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<TaskController>().loadAll(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
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
                          Text('$total', style: AppTypography.title),
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
                          Text('$selesai', style: AppTypography.title),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              if (c.loading) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: AppSpacing.lg),
              ] else if (c.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(color: AppColors.danger.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.error!,
                          style: AppTypography.muted.copyWith(color: AppColors.danger),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.read<TaskController>().loadAll(),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              Align(
                alignment: Alignment.centerLeft,
                child: Text('Tugas Terdekat', style: AppTypography.subtitle),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (!c.loading && nearestTop.isEmpty)
                Text('Belum ada tugas.', style: AppTypography.muted)
              else
                ...nearestTop.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TaskTile(
                      task: t,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: t.id,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
