create or replace function public.current_user_profile()
returns table (
    family_id uuid,
    role text,
    status text
)
language sql
stable
security definer
set search_path = public
as $$
    select
        p.family_id,
        p.role,
        p.status
    from public.profiles p
    where p.id = auth.uid()
    limit 1;
$$;

revoke execute on function public.current_user_profile() from public;
grant execute on function public.current_user_profile() to authenticated;