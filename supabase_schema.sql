-- Nectar Supabase schema.
-- Run this once in the Supabase SQL editor for the project. Row-level security
-- scopes every row to its owning auth user.

create table if not exists user_goals (
  user_id uuid references auth.users on delete cascade primary key,
  daily_kcal int not null default 2000,
  protein_g float8 not null default 60,
  carbs_g float8 not null default 200,
  fat_g float8 not null default 65,
  start_weight_kg float8 not null default 80,
  goal_weight_kg float8 not null default 70,
  updated_at timestamptz default now()
);
alter table user_goals enable row level security;
create policy "own" on user_goals using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists meal_entries (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  logged_at timestamptz not null,
  name text not null,
  image_path text,
  kcal int not null,
  protein_g float8 not null default 0,
  carbs_g float8 not null default 0,
  fat_g float8 not null default 0,
  fiber_g float8 default 0,
  sugar_g float8 default 0,
  sodium_mg float8 default 0
);
alter table meal_entries enable row level security;
create policy "own" on meal_entries using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists weight_entries (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  value_kg float8 not null,
  logged_at timestamptz not null default now()
);
alter table weight_entries enable row level security;
create policy "own" on weight_entries using (auth.uid() = user_id) with check (auth.uid() = user_id);
