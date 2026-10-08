create table public.families (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    status text not null default 'active',
    created_at timestamptz not null default now(),

    constraint families_status_check
        check (status in ('active', 'disabled'))
);