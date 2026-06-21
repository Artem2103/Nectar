import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Root widget of the Nectar application.
///
/// Wires the Material 3 theme and the GoRouter together. The router is built
/// once and held for the widget's lifetime so navigation state persists across
/// rebuilds.
class NectarApp extends StatefulWidget {
  const NectarApp({super.key});

  @override
  State<NectarApp> createState() => _NectarAppState();
}

class _NectarAppState extends State<NectarApp> {
  late final GoRouter _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nectar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
