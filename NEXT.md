# Next session prompt (paste into Opus / Claude Code)

Read todo.txt and your memory (MEMORY.md / project_nectar.md) before doing anything.

## 0. BLOCKER — do this first (one manual step, outside the app)

The micronutrient goals shipped last session need three new columns on Supabase,
or saving goals will throw. Run this once in the Supabase SQL editor:

    alter table user_goals
      add column fiber_g   double precision default 30,
      add column sugar_g   double precision default 50,
      add column sodium_mg double precision default 2300;

After running it, save the Goals & targets form once and confirm the carousel's
2nd page (fiber/sugar/sodium) reflects the saved targets. If you can't run SQL
yourself, tell me and I'll do it — don't skip it.

## Then work in this order, committing after each logically complete chunk:

1. Verify dark mode end-to-end (last session was the big migration):
   - Toggle Appearance → Dark and walk every screen (Home carousel, Progress
     chart + sheets, Add Meal, Goals, Profile, auth screens). Look for any
     remaining light-on-light or dark-on-dark: leftover hardcoded AppColors,
     const decorations that didn't get de-consted, or text with no themed color.
   - Check the bottom-sheet pickers and dialogs (theme/units sheets, badges
     dialog, edit-name dialog) since those float above the Scaffold.
   - The two CustomPainters (weight chart grid/line, calendar day ring) take
     colors as params now — confirm they read correctly on dark.
   Fix anything that didn't flip. `flutter analyze` must stay clean.

2. Show the new micros on Home where it makes sense:
   - MealCard currently prints only "P / C / F". Decide whether to add fiber/
     sugar/sodium there (or keep the card compact and surface them only in a
     meal-detail view). Low effort, improves the payoff of capturing them.

3. Meal editing (still an open gap): tapping a MealCard should open AddMeal
   pre-filled for edit (reuse AddMealScreen with an optional MealEntry arg);
   right now meals can only be deleted (swipe), not edited.

4. Notifications: the toggles persist but schedule nothing. Wire real local
   notifications (flutter_local_notifications) for meal reminders / weigh-in
   reminders / streak nudges, gated on the existing settings flags.

## Larger items still open (pick with me before starting):

- Day navigation / meal history: CalendarStrip is display-only and Home shows
  only today's meals. Make days tappable and load that day's meals — this is the
  biggest usability gap.
- Goal type (lose / maintain / gain) + weekly rate, and personal details
  (age/sex/height/activity) to drive smarter goal suggestions.
- Subscription/paywall + premium gating for AI photo analysis.
- Groups tab is still a maintenance stub.

## Rules

- Match the existing code style, design tokens, and feature-first structure.
  For colors that differ between light/dark use `context.colors.<token>`
  (NectarColors); only use raw `AppColors` for brand colors and the mid-grey
  secondary/tertiary text. Reuse widgets, don't reinvent.
- After each chunk: run `flutter analyze`, fix all issues, update todo.txt
  checkboxes, and update memory if anything notable changed.
- Ask me before any destructive or irreversible action (incl. Supabase schema
  changes beyond the additive one above).

---

Quick-wins-only alternative (if you just want a short session):

Read todo.txt, run the Supabase column migration above, verify dark mode across
all screens and fix any widgets that didn't flip, run flutter analyze, update the
todo.
