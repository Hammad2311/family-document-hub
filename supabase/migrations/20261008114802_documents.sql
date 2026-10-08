create table public.documents (
    id uuid primary key default gen_random_uuid(),
    family_id uuid not null references public.families(id) on delete restrict,
    profile_id uuid not null references public.profiles(id) on delete restrict,
    category_id uuid not null references public.document_categories(id) on delete restrict,
    file_name text not null,
    storage_path text not null unique,
    file_size_bytes bigint not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),

    constraint documents_file_size_check
        check (file_size_bytes > 0 and file_size_bytes <= 10485760)
);