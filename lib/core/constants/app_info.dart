/// Static metadata about the application itself.
///
/// Kept here (rather than read from the platform via a plugin) so the About
/// section can render synchronously with no extra dependency. Bump [version] in
/// step with `pubspec.yaml` when releasing.
abstract final class AppInfo {
  const AppInfo._();

  /// Marketing name shown in the UI.
  static const String name = 'Nectar';

  /// Human-readable version, mirroring the `version` field in `pubspec.yaml`.
  static const String version = '1.0.0';
}
