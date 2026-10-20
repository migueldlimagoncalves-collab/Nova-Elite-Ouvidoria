-- Execute no SQL Editor do Supabase.
create extension if not exists pgcrypto;

create table if not exists public.manifestations (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  identity_mode text not null check (identity_mode in ('anonymous','identified')),
  display_name text,
  contact text,
  category text not null check (category in ('Sugestão','Reclamação','Elogio','Ideia de projeto','Preocupação ou relato','Outro')),
  subject text not null check (char_length(subject) between 1 and 120),
  message text not null check (char_length(message) between 1 and 5000),
  status text not null default 'Recebida' check (status in ('Recebida','Em análise','Respondida','Concluída'))
);

alter table public.manifestations enable row level security;

-- O público só pode enviar uma nova manifestação; não pode ler ou editar registros.
drop policy if exists "public can submit manifestations" on public.manifestations;
create policy "public can submit manifestations"
on public.manifestations for insert to anon, authenticated
with check (
  (identity_mode = 'anonymous' and display_name is null and contact is null)
  or identity_mode = 'identified'
);

-- Apenas contas autenticadas com papel administrativo poderão ler/atualizar.
-- Crie a tabela admin_users e insira nela o UUID de cada conta autorizada.
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admin_users enable row level security;

drop policy if exists "admins can read manifestations" on public.manifestations;
create policy "admins can read manifestations"
on public.manifestations for select to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "admins can update manifestations" on public.manifestations;
create policy "admins can update manifestations"
on public.manifestations for update to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

alter table public.admin_users enable row level security;
-- Sem políticas para admin_users: usuários comuns não podem consultar/alterar essa lista.
