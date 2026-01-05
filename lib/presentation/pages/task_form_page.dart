import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../widgets/ds_button.dart';
import '../widgets/ds_card.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _titleC = TextEditingController();
  final _noteC = TextEditingController();
  final _deadlineC = TextEditingController();

  String? _titleError;
  String? _selectedCourse;
  DateTime? _deadline;
  bool _done = false;

  final List<String> _courses = const [
    'Pemrograman Lanjut',
    'Rekayasa Perangkat Lunak',
    'UI Engineering',
    'Metodologi Penelitian',
    'KKN Tematik',
  ];

  @override
  void dispose() {
    _titleC.dispose();
    _noteC.dispose();
    _deadlineC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TaskController>();

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
          'Tambah Tugas',
          style: AppTypography.subtitle.copyWith(fontSize: 16),
        ),
      ),

      // tombol bawah (API aware)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            8,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: DsButton(
                  text: 'Batal',
                  outlined: true,
                  onPressed: c.loading ? null : () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DsButton(
                  text: c.loading ? 'Menyimpan...' : 'Simpan',
                  onPressed: c.loading ? null : _onSave,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              DsCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Judul Tugas'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleC,
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul tugas',
                        hintStyle: AppTypography.muted,
                        filled: true,
                        fillColor: AppColors.surface,
                        errorText: _titleError,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius),
                          borderSide: BorderSide(
                            color: _titleError != null
                                ? AppColors.danger
                                : AppColors.border,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        if (_titleError != null &&
                            _titleC.text.trim().isNotEmpty) {
                          setState(() => _titleError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    _Label('Mata Kuliah'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCourse,
                      isExpanded: true,
                      hint: Text('Pilih mata kuliah',
                          style: AppTypography.muted),
                      items: _courses
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedCourse = v),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),

                    const SizedBox(height: 14),

                    _Label('Deadline'),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radius),
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _deadlineC,
                          decoration: InputDecoration(
                            hintText: 'Pilih tanggal',
                            hintStyle: AppTypography.muted,
                            filled: true,
                            fillColor: AppColors.surface,
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radius),
                              borderSide: const BorderSide(
                                  color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radius),
                              borderSide: const BorderSide(
                                  color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Checkbox(
                          value: _done,
                          onChanged: (v) =>
                              setState(() => _done = v ?? false),
                        ),
                        Text('Tugas sudah selesai',
                            style: AppTypography.body),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _Label('Catatan'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius),
                        border:
                            Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _noteC,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Catatan tambahan (opsional)',
                          hintStyle: AppTypography.muted,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    final c = context.read<TaskController>();

    final title = _titleC.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Judul tugas wajib diisi');
      return;
    }
    setState(() => _titleError = null);

    if (_selectedCourse == null) {
      _snack('Mata kuliah wajib dipilih');
      return;
    }
    if (_deadline == null) {
      _snack('Deadline wajib dipilih');
      return;
    }

    try {
      await c.addTaskRemote(
        title: title,
        course: _selectedCourse!,
        deadline: _deadline!,
        isDone: _done,
        note: _noteC.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      _snack('Gagal menambahkan tugas');
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _deadline ?? now,
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
        _deadlineC.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.subtitle);
  }
}
