import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  // ProviderScope hosts all Riverpod state for the app; feature providers are
  // registered lazily from within their own feature folders.
  runApp(const ProviderScope(child: NectarApp()));
}
