-- =========================================================
-- PRIVATE FAMILY DOCUMENT STORAGE
-- =========================================================

-- Create the private storage bucket.
insert into storage.buckets (
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
)
values (
    'family-documents',
    'family-documents',
    false,
    10485760,
    array['application/pdf']
)
on conflict (id) do update
set
    public = false,
    file_size_limit = 10485760,
    allowed_mime_types = array['application/pdf'];


-- =========================================================
-- STORAGE READ POLICY
-- =========================================================
-- Expected object path:
-- families/{family_id}/members/{profile_id}/documents/{document_id}.pdf
--
-- The first path segment is the family UUID.
-- The profile_id must also belong to that same family.

create policy "family_documents_select_same_family"
on storage.objects
for select
to authenticated
using (
    bucket_id = 'family-documents'
    and (storage.foldername(name))[1] =
        (
            select family_id::text
            from public.current_user_profile()
        )
);


-- =========================================================
-- STORAGE INSERT POLICY
-- =========================================================
-- Normal authenticated members cannot upload documents directly.
-- V1 uploads will be performed through the controlled admin
-- operation that we will implement later.

-- No INSERT policy intentionally.


-- =========================================================
-- STORAGE UPDATE POLICY
-- =========================================================
-- Normal authenticated members cannot replace files directly.

-- No UPDATE policy intentionally.


-- =========================================================
-- STORAGE DELETE POLICY
-- =========================================================
-- Normal authenticated members cannot delete files directly.

-- No DELETE policy intentionally.