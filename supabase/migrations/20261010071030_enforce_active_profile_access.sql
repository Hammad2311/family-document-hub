-- =========================================================
-- REQUIRE ACTIVE PROFILES FOR APPLICATION DATA ACCESS
-- =========================================================
-- An authenticated user must have an active profile to
-- read family data, profiles, categories, and documents.

-- ---------------------------------------------------------
-- FAMILIES
-- ---------------------------------------------------------

drop policy if exists "families_select_own"
on public.families;

create policy "families_select_own"
on public.families
for select
to authenticated
using (
    id = (
        select family_id
        from public.current_user_profile()
    )
    and (
        select status
        from public.current_user_profile()
    ) = 'active'
);


-- ---------------------------------------------------------
-- PROFILES
-- ---------------------------------------------------------

drop policy if exists "profiles_select_same_family"
on public.profiles;

create policy "profiles_select_same_family"
on public.profiles
for select
to authenticated
using (
    family_id = (
        select family_id
        from public.current_user_profile()
    )
    and (
        select status
        from public.current_user_profile()
    ) = 'active'
);


-- ---------------------------------------------------------
-- DOCUMENT CATEGORIES
-- ---------------------------------------------------------

drop policy if exists "document_categories_select_authenticated"
on public.document_categories;

create policy "document_categories_select_authenticated"
on public.document_categories
for select
to authenticated
using (
    (
        select status
        from public.current_user_profile()
    ) = 'active'
);


-- ---------------------------------------------------------
-- DOCUMENTS
-- ---------------------------------------------------------

drop policy if exists "documents_select_same_family"
on public.documents;

create policy "documents_select_same_family"
on public.documents
for select
to authenticated
using (
    family_id = (
        select family_id
        from public.current_user_profile()
    )
    and (
        select status
        from public.current_user_profile()
    ) = 'active'
);


-- ---------------------------------------------------------
-- PRIVATE STORAGE
-- ---------------------------------------------------------

drop policy if exists "family_documents_select_same_family"
on storage.objects;

create policy "family_documents_select_same_family"
on storage.objects
for select
to authenticated
using (
    bucket_id = 'family-documents'
    and (storage.foldername(name))[2] = (
        select family_id::text
        from public.current_user_profile()
    )
    and (
        select status
        from public.current_user_profile()
    ) = 'active'
);

