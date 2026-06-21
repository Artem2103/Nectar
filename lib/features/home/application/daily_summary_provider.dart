import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/daily_summary.dart';

/// Provides the [DailySummary] driving the Home screen.
///
/// For the MVP this exposes the placeholder figures from `Nectar.pdf`. When real
/// meal tracking lands, swap the body for a repository-backed provider — every
/// consuming widget already reads through this single seam.
final dailySummaryProvider = Provider<DailySummary>(
  (ref) => DailySummary.placeholder(),
);
