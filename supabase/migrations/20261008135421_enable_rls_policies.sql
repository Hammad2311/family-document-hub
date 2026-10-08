-- Enable Row Level Security on all application tables.
alter table public.families enable row level security;
alter table public.profiles enable row level security;
alter table public.document_categories enable row level security;
alter table public.documents enable row level security;


-- Families:
-- Authenticated users can view only their own family.
create policy "families_select_own"
on public.families
for select
to authenticated
using (
    id = (select family_id from public.current_user_profile())
);


-- Profiles:
-- Authenticated users can view profiles belonging to their own family.
create policy "profiles_select_same_family"
on public.profiles
for select
to authenticated
using (
    family_id = (select family_id from public.current_user_profile())
);


-- Document categories:
-- All authenticated users can read the fixed global category list.
create policy "document_categories_select_authenticated"
on public.document_categories
for select
to authenticated
using (true);


-- Documents:
-- Authenticated users can view documents belonging to their own family.
create policy "documents_select_same_family"
on public.documents
for select
to authenticated
using (
    family_id = (select family_id from public.current_user_profile())
);