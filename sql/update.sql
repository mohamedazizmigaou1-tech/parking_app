-- ============================================================
-- Parameters
-- ============================================================

\set id_commune 1
\set code_postal 75000
\set nom_commune 'Paris'

\set id_parking 1
\set nom_parking 'Parking Exemple'
\set type_parking 'Souterrain'
\set adresse 'Rue Exemple'
\set capacite 100

\set id_categorie_place 1
\set type_place 'Voiture'

\set id_place 1
\set num_place 'A01'
\set etat_place 'Libre'

\set id_utilisateur 1
\set p_identite 'AB123456'

\set id_vehicule 1
\set num_immatriculation 'AB-123-CD'
\set marque_vehicule 'Renault'
\set genre_vehicule 'Voiture'
\set date_de_fabrication '2020-01-01'
\set etat_vehicule 'Bon'
\set kilometrage 10000

\set id_abonnement 1
\set date_debut_abonnement '2024-01-01'
\set date_fin_abonnement '2024-12-31'
\set type_abonnement 'AU'
\set tarif_mensuel_abonnement 80.00

\set id_stationnement 1
\set date_debut '2024-05-10'
\set date_fin '2024-05-10'
\set heure_debut '08:00'
\set heure_fin '18:00'
\set mode_paiement 'Carte'
\set id_place 1

\set id_tarif 1
\set prix 3.00
\set debut_creneau '08:00'
\set fin_creneau '18:00'

\set id_compte 1
\set identifiant 'jean.dupont'
\set mot_de_passe 'password123'
\set date_creation '2023-01-01'

-- ============================================================
-- TABLE commune
-- ============================================================
UPDATE commune
SET code_postal = :code_postal,
    nom_commune = :'nom_commune'
WHERE id_commune = :id_commune;

-- ============================================================
-- TABLE parking
-- ============================================================
UPDATE parking
SET nom_parking = :'nom_parking',
    type_parking = :'type_parking',
    adresse = :'adresse',
    capacite = :capacite,
    id_commune = :id_commune
WHERE id_parking = :id_parking;

-- ============================================================
-- TABLE categorie_place
-- ============================================================
UPDATE categorie_place
SET type_place = :'type_place'
WHERE id_categorie_place = :id_categorie_place;

-- ============================================================
-- TABLE place
-- ============================================================
UPDATE place
SET num_place = :'num_place',
    etat_place = :'etat_place',
    id_parking = :id_parking,
    id_categorie_place = :id_categorie_place
WHERE id_place = :id_place;

-- ============================================================
-- TABLE utilisateur
-- ============================================================
UPDATE utilisateur
SET p_identite = :'p_identite'
WHERE id_utilisateur = :id_utilisateur;

-- ============================================================
-- TABLE vehicule
-- ============================================================
UPDATE vehicule
SET num_immatriculation = :'num_immatriculation',
    marque_vehicule = :'marque_vehicule',
    genre_vehicule = :'genre_vehicule',
    date_de_fabrication = :'date_de_fabrication',
    etat_vehicule = :'etat_vehicule',
    kilometrage = :kilometrage,
    id_utilisateur = :id_utilisateur
WHERE id_vehicule = :id_vehicule;

-- ============================================================
-- TABLE abonnement
-- ============================================================
UPDATE abonnement
SET date_debut_abonnement = :'date_debut_abonnement',
    date_fin_abonnement = :'date_fin_abonnement',
    type_abonnement = :'type_abonnement',
    tarif_mensuel_abonnement = :tarif_mensuel_abonnement
WHERE id_abonnement = :id_abonnement;

-- ============================================================
-- TABLE posseder_av
-- ============================================================
UPDATE posseder_av
SET id_abonnement = :id_abonnement
WHERE id_vehicule = :id_vehicule;

-- ============================================================
-- TABLE posseder_au
-- ============================================================
UPDATE posseder_au
SET id_abonnement = :id_abonnement
WHERE id_utilisateur = :id_utilisateur;

-- ============================================================
-- TABLE stationnement
-- ============================================================
UPDATE stationnement
SET date_debut = :'date_debut',
    date_fin = :'date_fin',
    heure_debut = :'heure_debut',
    heure_fin = :'heure_fin',
    mode_paiement = :'mode_paiement',
    id_vehicule = :id_vehicule,
    id_place = :id_place,
    id_utilisateur = :id_utilisateur
WHERE id_stationnement = :id_stationnement;

-- ============================================================
-- TABLE tarif
-- ============================================================
UPDATE tarif
SET id_tarif = :id_tarif
WHERE id_tarif = :id_tarif;

-- ============================================================
-- TABLE creneau
-- ============================================================
UPDATE creneau
SET prix = :prix,
    debut_creneau = :'debut_creneau',
    fin_creneau = :'fin_creneau'
WHERE id_creneau = :id_creneau;

-- ============================================================
-- TABLE diviser
-- ============================================================
UPDATE diviser
SET id_tarif = :id_tarif
WHERE id_creneau = :id_creneau;

-- ============================================================
-- TABLE compte
-- ============================================================
UPDATE compte
SET identifiant = :'identifiant',
    mot_de_passe = :'mot_de_passe',
    date_creation = :'date_creation',
    id_utilisateur = :id_utilisateur
WHERE id_compte = :id_compte;

-- ============================================================
-- TABLE appliquer
-- ============================================================
UPDATE appliquer
SET id_tarif = :id_tarif
WHERE id_parking = :id_parking AND id_categorie_place = :id_categorie_place;

-- ============================================================
-- TABLE proposer_auv
-- ============================================================
UPDATE proposer_auv
SET id_parking = :id_parking
WHERE id_abonnement = :id_abonnement;
