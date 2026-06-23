import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/nectar_colors.dart';
import '../../../profile/application/settings_provider.dart';
import '../../../profile/domain/app_settings.dart';
import '../../application/weight_provider.dart';
import '../../domain/weight_entry.dart';

/// Opens the bottom sheet for recording a new weigh-in, pre-filled with the
/// user's current weight (already in the active display unit).
Future<void> showLogWeightSheet(
  BuildContext context,
  WidgetRef ref, {
  required double currentWeight,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LogWeightSheet(ref: ref, currentWeight: currentWeight),
  );
}

class _LogWeightSheet extends StatefulWidget {
  const _LogWeightSheet({required this.ref, required this.currentWeight});

  final WidgetRef ref;
  final double currentWeight;

  @override
  State<_LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<_LogWeightSheet> {
  late final UnitSystem _units =
      widget.ref.read(settingsProvider).value?.units ?? UnitSystem.metric;
  late final TextEditingController _value =
      TextEditingController(text: widget.currentWeight.toStringAsFixed(1));
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final parsed = double.tryParse(_value.text.trim());
    if (parsed == null || parsed <= 0) {
      setState(() => _error = 'Enter a valid weight');
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await widget.ref.read(weightRepositoryProvider.notifier).addWeight(
            WeightEntry(
              id: const Uuid().v4(),
              userId: supabase.auth.currentUser!.id,
              // The field is in the user's display unit; persist in kg.
              valueKg: _units.weightToKg(parsed),
              timestamp: DateTime.now(),
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Couldn't save: $e";
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Log weight', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _value,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: AppTypography.body,
              decoration: InputDecoration(
                labelText: 'Weight (${_units.weightLabel})',
                labelStyle: AppTypography.label,
                errorText: _error,
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
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: Text(
                _busy ? 'Saving…' : 'Save',
                style: AppTypography.titleMedium
                    .copyWith(color: context.colors.onInverse, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
