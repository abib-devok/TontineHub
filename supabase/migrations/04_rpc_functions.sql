-- Fonction pour récupérer toutes les tontines associées à l'utilisateur actuel
-- (soit en tant que propriétaire, soit en tant que membre).
CREATE OR REPLACE FUNCTION get_user_tontines()
RETURNS TABLE (
  id UUID,
  name TEXT,
  rules_json JSONB,
  owner_id UUID
) AS $$
BEGIN
  RETURN QUERY
    SELECT t.id, t.name, t.rules_json, t.owner_id
    FROM public.tontines t
    WHERE t.owner_id = auth.uid()
    UNION
    SELECT t.id, t.name, t.rules_json, t.owner_id
    FROM public.tontines t
    JOIN public.tontine_members tm ON t.id = tm.tontine_id
    WHERE tm.user_id = auth.uid();
END;
$$ LANGUAGE plpgsql;
