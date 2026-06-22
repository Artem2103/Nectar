import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';

/// A labelled text field matching the app's form styling, shared across the
/// login, register and onboarding screens.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.label,
        filled: true,
        fillColor: AppColors.surface,
        border: const OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
