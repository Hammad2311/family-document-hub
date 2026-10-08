alter table public.profiles
    add constraint profiles_id_family_id_key
    unique (id, family_id);

alter table public.documents
    add constraint documents_profile_family_fkey
    foreign key (profile_id, family_id)
    references public.profiles (id, family_id)
    on delete restrict;