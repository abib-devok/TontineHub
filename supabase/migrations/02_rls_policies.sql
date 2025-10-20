-- Étape 1: Activer la sécurité au niveau des lignes (RLS) pour chaque table
-- C'est une mesure de sécurité cruciale pour s'assurer que les utilisateurs n'accèdent qu'aux données autorisées.
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tontines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;


-- Étape 2: Définir les politiques RLS pour la table 'users'
-- Les utilisateurs ne peuvent voir et modifier que leur propre profil.
CREATE POLICY "Les utilisateurs peuvent voir leur propre profil"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Les utilisateurs peuvent mettre à jour leur propre profil"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);


-- Étape 3: Définir les politiques RLS pour la table 'tontines'
-- Pour l'instant, une politique simple : les utilisateurs authentifiés peuvent voir toutes les tontines.
-- Une politique plus stricte nécessiterait une table de jointure pour les membres (ex: tontine_members).
-- Pour la création, seul un utilisateur authentifié peut créer une tontine.
CREATE POLICY "Les utilisateurs authentifiés peuvent voir les tontines"
  ON public.tontines FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Les utilisateurs peuvent créer des tontines"
  ON public.tontines FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

-- Seul le propriétaire peut modifier ou supprimer sa tontine.
CREATE POLICY "Les propriétaires peuvent mettre à jour leurs tontines"
  ON public.tontines FOR UPDATE
  USING (auth.uid() = owner_id);

CREATE POLICY "Les propriétaires peuvent supprimer leurs tontines"
  ON public.tontines FOR DELETE
  USING (auth.uid() = owner_id);


-- Étape 4: Définir les politiques RLS pour la table 'payments'
-- Les utilisateurs ne peuvent voir que les paiements liés à leurs tontines (simplifié, nécessite une jointure pour être précis).
-- Pour l'instant, permet de voir ses propres paiements.
CREATE POLICY "Les utilisateurs peuvent voir leurs propres paiements"
  ON public.payments FOR SELECT
  USING (auth.uid() = user_id);

-- Les utilisateurs ne peuvent créer que des paiements pour eux-mêmes.
CREATE POLICY "Les utilisateurs peuvent créer leurs propres paiements"
  ON public.payments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Les utilisateurs ne peuvent pas modifier leurs paiements (principe d'immuabilité des transactions).
-- Seul un administrateur pourrait le faire (non implémenté ici).
