import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/meal_entry.dart';
import 'meal_repository.dart';

/// The async-loaded list of every logged [MealEntry].
///
/// Read the list with `ref.watch(mealRepositoryProvider)` and mutate it via
/// `ref.read(mealRepositoryProvider.notifier).addMeal(...)`.
final mealRepositoryProvider =
    AsyncNotifierProvider<MealRepository, List<MealEntry>>(
  MealRepository.new,
);
