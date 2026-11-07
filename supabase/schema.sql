create extension if not exists pgcrypto;

create table if not exists public.observations (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('critical', 'open', 'tree', 'hardscape', 'grass', 'hard', 'exposed')),
  urgency text not null default 'potential' check (urgency in ('urgent', 'potential', 'conserved', 'ineligible')),
  note text not null default '' check (char_length(note) <= 250),
  photo text,
  lat double precision not null check (lat between -6.50 and -5.90),
  lng double precision not null check (lng between 106.50 and 107.20),
  created_at timestamptz not null default now()
);

alter table public.observations enable row level security;

drop policy if exists "public can read observations" on public.observations;
create policy "public can read observations"
on public.observations
for select
to anon
using (true);

drop policy if exists "public can add observations" on public.observations;
create policy "public can add observations"
on public.observations
for insert
to anon
with check (
  category in ('critical', 'open', 'tree', 'hardscape', 'grass', 'hard', 'exposed')
  and urgency in ('urgent', 'potential', 'conserved', 'ineligible')
  and char_length(note) <= 250
  and lat between -6.50 and -5.90
  and lng between 106.50 and 107.20
);

create index if not exists observations_created_at_idx
on public.observations (created_at desc);
