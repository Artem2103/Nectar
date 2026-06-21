/// Typed references to bundled image assets.
///
/// File names in `assets/` are descriptive (and a few contain spaces), so they
/// are funnelled through these constants to avoid fragile inline strings and to
/// give a single place to rename or swap artwork. Grouped by usage.
abstract final class AppAssets {
  const AppAssets._();

  static const String _base = 'assets';

  // ── Brand ────────────────────────────────────────────────────────────────
  static const String logo = '$_base/logo.png';

  // ── Macronutrient icons ──────────────────────────────────────────────────
  static const String protein = '$_base/meat(proteins).png';
  static const String carbs = '$_base/bread(carbs).png';
  static const String fat = '$_base/avocado(fat).png';
  static const String fiber = '$_base/broccoli_1f966.png';
  static const String sugar = '$_base/lolipop(sugar).png';
  static const String sodium = '$_base/salt(sodium).png';

  // ── Activity & wellness ──────────────────────────────────────────────────
  static const String steps = '$_base/steps.jpg';
  static const String water = '$_base/water.png';
  static const String fireIcon = '$_base/fire icon.png';
  static const String fireStreak = '$_base/fire streak.png';
  static const String badges = '$_base/badges.png';
  static const String flag = '$_base/flag.png';

  // ── Meals ────────────────────────────────────────────────────────────────
  static const String mealSalad = '$_base/salad(recently uploaded).png';

  // ── Navigation glyphs (fallback artwork) ─────────────────────────────────
  static const String navHome = '$_base/home.png';
  static const String navProgress = '$_base/progress.png';
  static const String navGroups = '$_base/groups.jpg';
  static const String navProfile = '$_base/profile.jpg';

  // ── Illustrations ────────────────────────────────────────────────────────
  static const String maintenance =
      '$_base/Gemini_Generated_Image_9sams9sams9sams9 (1).png';
}
