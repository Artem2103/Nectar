import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/nectar_colors.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/screen_title.dart';
import '../application/meal_analyser.dart';
import '../application/meal_provider.dart';
import '../domain/meal_entry.dart';
import 'widgets/meal_image_picker.dart';

/// Full-screen flow for logging a meal: pick a photo, optionally let the vision
/// model estimate its macros, edit the figures, then save.
class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  final _fiber = TextEditingController();
  final _sugar = TextEditingController();
  final _sodium = TextEditingController();

  File? _image;
  bool _analysing = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _name,
      _kcal,
      _protein,
      _carbs,
      _fat,
      _fiber,
      _sugar,
      _sodium,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text('Take photo', style: AppTypography.body),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text('Choose from gallery', style: AppTypography.body),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;
    setState(() => _image = File(picked.path));
  }

  Future<void> _analyse() async {
    final image = _image;
    if (image == null) return;
    setState(() => _analysing = true);
    try {
      final result = await analyseImage(image);
      _name.text = result.name;
      _kcal.text = result.kcal.toString();
      _protein.text = result.proteinG.toStringAsFixed(0);
      _carbs.text = result.carbsG.toStringAsFixed(0);
      _fat.text = result.fatG.toStringAsFixed(0);
      _fiber.text = result.fiberG.toStringAsFixed(0);
      _sugar.text = result.sugarG.toStringAsFixed(0);
      _sodium.text = result.sodiumMg.toStringAsFixed(0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Couldn't analyse photo: $e")));
      }
    } finally {
      if (mounted) setState(() => _analysing = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(mealRepositoryProvider.notifier);
    final id = const Uuid().v4();
    try {
      String? imageUrl;
      final image = _image;
      if (image != null) {
        imageUrl = await repo.uploadImage(image, id);
      }
      final entry = MealEntry(
        id: id,
        timestamp: DateTime.now(),
        name: _name.text.trim(),
        imagePath: imageUrl,
        kcal: int.parse(_kcal.text),
        proteinG: double.parse(_protein.text),
        carbsG: double.parse(_carbs.text),
        fatG: double.parse(_fat.text),
        fiberG: double.tryParse(_fiber.text) ?? 0,
        sugarG: double.tryParse(_sugar.text) ?? 0,
        sodiumMg: double.tryParse(_sodium.text) ?? 0,
      );
      await repo.addMeal(entry);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Couldn't save meal: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Opaque scaffold (not transparent) so the strip the keyboard vacates
      // doesn't flash the black OS window during the close animation.
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHPadding,
              AppSpacing.md,
              AppSpacing.screenHPadding,
              AppSpacing.xxl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: context.colors.textPrimary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const ScreenTitle('Add Meal'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  MealImagePicker(image: _image, onTap: _pickImage),
                  const SizedBox(height: AppSpacing.xl),
                  _Field(
                    controller: _name,
                    label: 'Meal name',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          controller: _kcal,
                          label: 'Calories',
                          number: true,
                          integer: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          controller: _protein,
                          label: 'Protein g',
                          number: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          controller: _carbs,
                          label: 'Carbs g',
                          number: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          controller: _fat,
                          label: 'Fat g',
                          number: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          controller: _fiber,
                          label: 'Fiber g',
                          number: true,
                          optional: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          controller: _sugar,
                          label: 'Sugar g',
                          number: true,
                          optional: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _Field(
                          controller: _sodium,
                          label: 'Sodium mg',
                          number: true,
                          optional: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      PillButton(
                        label: _analysing ? 'Analysing…' : 'Analyse photo',
                        icon: Icons.auto_awesome_rounded,
                        onPressed: (_image == null || _analysing || _saving)
                            ? null
                            : _analyse,
                      ),
                      const Spacer(),
                      PillButton(
                        label: _saving ? 'Saving…' : 'Save meal',
                        icon: Icons.check_rounded,
                        onPressed: (_analysing || _saving) ? null : _save,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled [TextFormField] matching the app's typography, with optional
/// numeric-only input and validation.
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.number = false,
    this.integer = false,
    this.optional = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool number;
  final bool integer;

  /// When true a blank numeric field is accepted (treated as zero on save).
  final bool optional;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: number
          ? TextInputType.numberWithOptions(decimal: !integer)
          : TextInputType.text,
      inputFormatters: number
          ? [
              FilteringTextInputFormatter.allow(
                integer ? RegExp(r'[0-9]') : RegExp(r'[0-9.]'),
              ),
            ]
          : null,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.label,
        filled: true,
        fillColor: context.colors.surface,
        border: OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: context.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: context.colors.border),
        ),
      ),
      validator: validator ??
          (number
              ? (v) {
                  if (v == null || v.isEmpty) {
                    return optional ? null : 'Required';
                  }
                  final parsed =
                      integer ? int.tryParse(v) : double.tryParse(v);
                  return parsed == null ? 'Invalid' : null;
                }
              : null),
    );
  }
}
