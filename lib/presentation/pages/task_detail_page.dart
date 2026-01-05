import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/task.dart';
import '../widgets/ds_button.dart';
import '../widgets/ds_card.dart';
import '../widgets/status_pill.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TextEditingController? _noteC;

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

  @override
  void dispose() {
    _noteC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;

    final c = context.watch<TaskController>();
    final t = c.findById(id);

    if (t == null) {
      return const Scaffold(body: Center(child: Text('Tugas tidak ditemukan')));
    }

    _noteC ??= TextEditingController(text: t.note);

    final uiStatus = _statusForUi(t);

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Detail Tugas',
          style: AppTypography.subtitle.copyWith(fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(
              child: Text('Edit', style: TextStyle(color: AppColors.primary)),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            8,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: DsButton(
            text: c.loading ? 'Menyimpan...' : 'Simpan Perubahan',
            onPressed: c.loading
                ? null
                : () async {
                    try {
                      await context.read<TaskController>().updateNoteRemote(
                        id,
                        _noteC!.text,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perubahan disimpan')),
                      );
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menyimpan perubahan'),
                        ),
                      );
                    }
                  },
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: DsCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Judul Tugas', style: AppTypography.muted),
                        const SizedBox(height: 4),
                        Text(t.title, style: AppTypography.subtitle),
                        const SizedBox(height: 12),
                        Text('Mata Kuliah', style: AppTypography.muted),
                        const SizedBox(height: 4),
                        Text(t.course, style: AppTypography.body),
                        const SizedBox(height: 12),
                        Text('Deadline', style: AppTypography.muted),
                        const SizedBox(height: 4),
                        Text(_fmtDate(t.deadline), style: AppTypography.body),
                        const SizedBox(height: 12),
                        Text('Status', style: AppTypography.muted),
                        const SizedBox(height: 8),
                        StatusPill(status: uiStatus),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text('Penyelesaian', style: AppTypography.subtitle),
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: t.isDone,
                    onChanged: c.loading
                        ? null
                        : (v) async {
                            try {
                              await context
                                  .read<TaskController>()
                                  .toggleDoneRemote(id, v ?? false);
                            } catch (_) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal update status'),
                                ),
                              );
                            }
                          },
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tugas sudah selesai', style: AppTypography.body),
                        const SizedBox(height: 2),
                        Text(
                          'Centang jika tugas sudah final.',
                          style: AppTypography.muted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Text('Catatan', style: AppTypography.subtitle),
              const SizedBox(height: 10),

              DsCard(
                padding: const EdgeInsets.all(14),
                child: TextField(
                  controller: _noteC,
                  maxLines: 4,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: AppTypography.body,
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
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
}
