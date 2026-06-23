# Next session prompt (paste into Opus / Claude Code)

Read todo.txt and your memory (MEMORY.md / project_nectar.md) before doing anything.

Work in this order, committing after each logically complete chunk:

1. Bugs first (fast, visible wins):
   - Fix the NutritionCarousel 15px RenderFlex overflow on Home.
   - Fix carousel pages touching — give symmetric horizontal spacing/gutter
     between cards (viewportFraction + padding/peek). Both cards must look
     identically spaced.
   Run `flutter analyze` and verify the layout before moving on.

2. Then start Phase 5 — Profile expansion, beginning with "Foundation needed"
   (settings model + repository, reusable settings-list widgets, Riverpod theme
   controller wired to MaterialApp themeMode). Don't build feature screens until
   the foundation exists.

Skip the AI photo-analysis item — I'll do that later.

Rules:
- Match the existing code style, design tokens (AppColors/AppSpacing/etc.), and
  feature-first folder structure. Reuse widgets, don't reinvent.
- After each chunk: run `flutter analyze`, fix all issues, update todo.txt
  checkboxes, and update memory if anything notable changed.
- Ask me before any destructive or irreversible action.

---

Quick-wins-only alternative (if you just want the bugs fixed):

Read todo.txt, fix the two Home carousel bugs, run flutter analyze, update the todo.
