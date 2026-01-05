import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static const muted = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );
}
