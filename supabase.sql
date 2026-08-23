-- Mein Tagebuch PWA v2
-- In Supabase: SQL Editor -> New query -> entire file -> Run

create table if not exists public.journal_entries (
  user_id uuid not null references auth.users(id) on delete cascade,
  entry_date date not null,
  mood smallint not null default 3 check (mood between 1 and 5),
  energy smallint not null default 5 check (energy between 0 and 10),
  tension smallint not null default 5 check (tension between 0 and 10),
  sleep smallint not null default 3 check (sleep between 1 and 5),
  thoughts text not null default '',
  good text not null default '',
  hard text not null default '',
  helped text not null default '',
  moment text not null default '',
  tomorrow text not null default '',
  feelings text[] not null default '{}',
  selfcare text[] not null default '{}',
  client_modified_at timestamptz not null default now(),
  server_updated_at timestamptz not null default now(),
  primary key (user_id, entry_date)
);

create index if not exists journal_entries_user_id_idx
  on public.journal_entries (user_id);

create or replace function public.set_journal_server_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.server_updated_at = now();
  return new;
end;
$$;

drop trigger if exists journal_entries_set_updated_at on public.journal_entries;
create trigger journal_entries_set_updated_at
before update on public.journal_entries
for each row execute function public.set_journal_server_updated_at();

alter table public.journal_entries enable row level security;

-- Least privilege: signed-out visitors get no access.
revoke all on table public.journal_entries from anon, authenticated;
grant select, insert, update, delete on table public.journal_entries to authenticated;

drop policy if exists "journal_select_own" on public.journal_entries;
drop policy if exists "journal_insert_own" on public.journal_entries;
drop policy if exists "journal_update_own" on public.journal_entries;
drop policy if exists "journal_delete_own" on public.journal_entries;

create policy "journal_select_own"
on public.journal_entries
for select
to authenticated
using ((select auth.uid()) is not null and (select auth.uid()) = user_id);

create policy "journal_insert_own"
on public.journal_entries
for insert
to authenticated
with check ((select auth.uid()) is not null and (select auth.uid()) = user_id);

create policy "journal_update_own"
on public.journal_entries
for update
to authenticated
using ((select auth.uid()) is not null and (select auth.uid()) = user_id)
with check ((select auth.uid()) is not null and (select auth.uid()) = user_id);

create policy "journal_delete_own"
on public.journal_entries
for delete
to authenticated
using ((select auth.uid()) is not null and (select auth.uid()) = user_id);
