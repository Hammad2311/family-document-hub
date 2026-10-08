create table public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    family_id uuid not null references public.families(id) on delete restrict,
    full_name text not null,
    role text not null default 'member',
    status text not null default 'active',
    created_at timestamptz not null default now(),

    constraint profiles_role_check
        check (role in ('admin', 'member')),

    constraint profiles_status_check
        check (status in ('active', 'disabled'))
);