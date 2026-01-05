import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';

class DsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const DsCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
