create table public.document_categories (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    slug text not null unique,
    created_at timestamptz not null default now()
);