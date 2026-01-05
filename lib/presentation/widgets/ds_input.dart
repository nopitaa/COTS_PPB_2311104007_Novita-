import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class DsInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const DsInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.subtitle),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.muted,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: BorderSide(color: errorText != null ? AppColors.danger : AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
