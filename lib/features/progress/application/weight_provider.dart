import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/weight_entry.dart';
import 'weight_repository.dart';

/// The async-loaded list of every recorded [WeightEntry].
///
/// Read with `ref.watch(weightRepositoryProvider)` and append via
/// `ref.read(weightRepositoryProvider.notifier).addWeight(...)`.
final weightRepositoryProvider =
    AsyncNotifierProvider<WeightRepository, List<WeightEntry>>(
  WeightRepository.new,
);
