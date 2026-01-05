import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class DsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;

  const DsButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    if (outlined) {
      return SizedBox(
        height: 48,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: shape,
            side: const BorderSide(color: AppColors.border),
          ),
          onPressed: onPressed,
          child: Text(text, style: AppTypography.subtitle),
        ),
      );
    }

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: shape,
        ),
        onPressed: onPressed,
        child: Text(text, style: AppTypography.subtitle.copyWith(color: Colors.white)),
      ),
    );
  }
}
