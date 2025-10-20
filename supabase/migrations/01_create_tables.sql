-- Étape 1: Création de la table des utilisateurs (profils)
-- Cette table stocke les informations publiques des utilisateurs, liées à la table d'authentification de Supabase.
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone TEXT UNIQUE NOT NULL,
  profile_json JSONB,
  confiance_score NUMERIC DEFAULT 100,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.users IS 'Table pour stocker les profils des utilisateurs.';
-- Ajout d'un index sur le numéro de téléphone pour des recherches rapides.
CREATE INDEX idx_users_phone ON public.users(phone);


-- Étape 2: Création de la table des tontines
-- Chaque tontine a un propriétaire (owner_id) et des règles définies en JSON.
CREATE TABLE public.tontines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  rules_json JSONB,
  owner_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.tontines IS 'Table pour stocker les informations sur les tontines.';
-- Ajout d'un index sur le propriétaire pour filtrer rapidement les tontines par utilisateur.
CREATE INDEX idx_tontines_owner_id ON public.tontines(owner_id);


-- Étape 3: Création d'un type énuméré pour le statut des paiements
-- Utiliser un type ENUM garantit l'intégrité des données pour le statut.
CREATE TYPE payment_status AS ENUM ('pending', 'success', 'failed');


-- Étape 4: Création de la table des paiements
-- Enregistre chaque transaction effectuée au sein d'une tontine.
CREATE TABLE public.payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tontine_id UUID NOT NULL REFERENCES public.tontines(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL,
  status payment_status NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE public.payments IS 'Table pour enregistrer les paiements des membres des tontines.';
-- Ajout d'indexes pour accélérer les requêtes sur les tontines et les utilisateurs.
CREATE INDEX idx_payments_tontine_id ON public.payments(tontine_id);
CREATE INDEX idx_payments_user_id ON public.payments(user_id);


-- Étape 5: Création d'une fonction trigger pour mettre à jour le timestamp 'updated_at'
-- Cette fonction est appelée automatiquement avant chaque mise à jour de ligne.
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Étape 6: Attacher le trigger aux tables
-- Assure que 'updated_at' est toujours à jour.
CREATE TRIGGER on_users_update
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER on_tontines_update
  BEFORE UPDATE ON public.tontines
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();

CREATE TRIGGER on_payments_update
  BEFORE UPDATE ON public.payments
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();


-- Étape 7: Trigger pour la mise à jour du score de confiance après un paiement réussi
-- Placeholder pour la logique de mise à jour du score de confiance.
-- La logique exacte (e.g., +10 points) sera définie dans la fonction.
CREATE OR REPLACE FUNCTION update_confiance_score()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'success' THEN
    UPDATE public.users
    SET confiance_score = confiance_score + 10
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attacher le trigger à la table des paiements
CREATE TRIGGER on_successful_payment
  AFTER UPDATE OF status ON public.payments
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status)
  EXECUTE PROCEDURE update_confiance_score();
