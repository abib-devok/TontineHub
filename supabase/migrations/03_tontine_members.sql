-- Étape 1: Création de la table de liaison tontine_members
-- Cette table associe les utilisateurs aux tontines dont ils sont membres.
CREATE TABLE public.tontine_members (
  tontine_id UUID NOT NULL REFERENCES public.tontines(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (tontine_id, user_id)
);
COMMENT ON TABLE public.tontine_members IS 'Table de liaison pour les membres des tontines.';

-- Étape 2: Mise à jour de la politique RLS pour la table 'tontines'
-- Supprimer l'ancienne politique de sélection trop permissive.
DROP POLICY "Les utilisateurs authentifiés peuvent voir les tontines" ON public.tontines;

-- Nouvelle politique : les utilisateurs peuvent voir les tontines dont ils sont propriétaires OU membres.
CREATE POLICY "Les membres peuvent voir les tontines"
  ON public.tontines FOR SELECT
  USING (
    auth.uid() = owner_id
    OR
    EXISTS (
      SELECT 1
      FROM public.tontine_members
      WHERE tontine_members.tontine_id = tontines.id
      AND tontine_members.user_id = auth.uid()
    )
  );

-- Étape 3: Politiques RLS pour la nouvelle table 'tontine_members'
-- Les utilisateurs peuvent voir leur propre adhésion.
ALTER TABLE public.tontine_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les utilisateurs peuvent voir leur propre adhésion"
  ON public.tontine_members FOR SELECT
  USING (auth.uid() = user_id);

-- Un utilisateur peut s'ajouter à une tontine (rejoindre).
CREATE POLICY "Les utilisateurs peuvent rejoindre des tontines"
  ON public.tontine_members FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Un utilisateur peut quitter une tontine (se supprimer).
CREATE POLICY "Les utilisateurs peuvent quitter des tontines"
  ON public.tontine_members FOR DELETE
  USING (auth.uid() = user_id);
