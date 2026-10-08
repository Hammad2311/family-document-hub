-- Fix family folder index.
-- Storage path:
-- families/{family_id}/members/{profile_id}/documents/{document_id}.pdf
-- Therefore storage.foldername(name)[1] = "families"
-- and [2] = family_id.

drop policy if exists "family_documents_select_same_family"
on storage.objects;

create policy "family_documents_select_same_family"
on storage.objects
for select
to authenticated
using (
    bucket_id = 'family-documents'
    and (storage.foldername(name))[2] =
        (
            select family_id::text
            from public.current_user_profile()
        )
);