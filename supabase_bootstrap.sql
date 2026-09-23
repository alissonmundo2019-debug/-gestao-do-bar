create or replace function public.criar_meu_bar(nome_bar text)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_bar_id uuid; v_nome text;
begin
 if auth.uid() is null then raise exception 'Usuário não autenticado'; end if;
 select bar_id into v_bar_id from public.perfis where id=auth.uid() limit 1;
 if v_bar_id is not null then return v_bar_id; end if;
 v_nome:=nullif(trim(nome_bar),''); if v_nome is null then v_nome:='Meu Bar'; end if;
 insert into public.bares(nome) values(v_nome) returning id into v_bar_id;
 insert into public.perfis(id,bar_id) values(auth.uid(),v_bar_id);
 return v_bar_id;
end; $$;
grant execute on function public.criar_meu_bar(text) to authenticated;
