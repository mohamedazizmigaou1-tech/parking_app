
-- ========= Parameters =========
\set instant_ts '2025-12-04 10:30:00'
\set date_jour  '2025-12-04'
\set id_utilisateur '1'
\set id_vehicule '1'
\set id_parking '1'
\set id_tarif '1'
\set id_place '1'

-- =========  Liste des voitures par parking =========
SELECT DISTINCT
    p.id_parking,
    p.nom_parking,
    v.id_vehicule,
    v.num_immatriculation
FROM stationnement s
JOIN place pl ON s.id_place = pl.id_place
JOIN parking p ON pl.id_parking = p.id_parking
JOIN vehicule v ON s.id_vehicule = v.id_vehicule
ORDER BY p.nom_parking, v.num_immatriculation;

-- =========  Liste des parkings par commune =========
SELECT
    c.id_commune,
    c.nom_commune,
    p.id_parking,
    p.nom_parking
FROM parking p
JOIN commune c ON p.id_commune = c.id_commune
ORDER BY c.nom_commune, p.nom_parking;

-- =========  Parkings saturés à une date donnée (approx. journalière) =========
-- Hypothèse "saturation journalière": stationnement intersecte la date :date_jour
WITH places_par_parking AS (
    SELECT pl.id_parking, COUNT(*) AS nb_places
    FROM place pl
    GROUP BY pl.id_parking
),
stationnements_jour AS (
    SELECT
        pl.id_parking,
        s.id_stationnement
    FROM stationnement s
    JOIN place pl ON s.id_place = pl.id_place
    WHERE s.date_debut <= :'date_jour'::date
      AND s.date_fin   >= :'date_jour'::date
)
SELECT
    p.id_parking,
    p.nom_parking,
    p.capacite,
    COUNT(DISTINCT sj.id_stationnement) AS nb_stationnements_jour
FROM parking p
LEFT JOIN stationnements_jour sj ON sj.id_parking = p.id_parking
GROUP BY p.id_parking, p.nom_parking, p.capacite
HAVING COUNT(DISTINCT sj.id_stationnement) >= p.capacite
ORDER BY p.nom_parking;

-- =========  Parkings saturés à l’instant :'instant_ts' =========
-- Version "end-of-day" pour NULL heure_fin/date_fin (ongoing = actif jusqu’à 23:59:59 du jour)
WITH stationnements_intervalles AS (
    SELECT
        s.id_stationnement,
        s.id_place,
        (COALESCE(s.date_debut, s.date_fin)::timestamp
         + COALESCE(s.heure_debut::time, '00:00:00'::time)) AS ts_debut,
        (COALESCE(s.date_fin, s.date_debut)::timestamp
         + COALESCE(s.heure_fin::time, '23:59:59'::time))   AS ts_fin
    FROM stationnement s
),
places_occupees AS (
    SELECT DISTINCT si.id_place
    FROM stationnements_intervalles si
    WHERE :'instant_ts'::timestamp >= si.ts_debut
      AND :'instant_ts'::timestamp <  si.ts_fin
),
occupation_parking AS (
    SELECT pl.id_parking, COUNT(*) AS nb_places_occupees
    FROM places_occupees po
    JOIN place pl ON pl.id_place = po.id_place
    GROUP BY pl.id_parking
)
SELECT
    p.id_parking,
    p.nom_parking,
    p.capacite,
    op.nb_places_occupees AS nb_places_occupees
FROM parking p
LEFT JOIN occupation_parking op ON op.id_parking = p.id_parking
WHERE op.nb_places_occupees >= p.capacite
ORDER BY p.nom_parking;

-- =========  Places disponibles par parking à :'instant_ts' =========
WITH stationnements_intervalles AS (
    SELECT
        s.id_stationnement,
        s.id_place,
        (s.date_debut::timestamp + s.heure_debut::time) AS ts_debut,
        (s.date_fin::timestamp + s.heure_fin::time) AS ts_fin
    FROM stationnement s
),
places_occupees AS (
    SELECT DISTINCT si.id_place
    FROM stationnements_intervalles si
    WHERE :'instant_ts'::timestamp >= si.ts_debut
      AND :'instant_ts'::timestamp <  si.ts_fin
)
SELECT
    p.id_parking,
    p.nom_parking,
    pl.id_place,
    pl.num_place
FROM place pl
JOIN parking p ON p.id_parking = pl.id_parking
WHERE NOT EXISTS (
  SELECT 1 FROM places_occupees po WHERE po.id_place = pl.id_place
)
ORDER BY p.nom_parking, pl.num_place;

-- =========  Vehicule garées dans ≥ 2 parkings le :date_jour =========
SELECT
    v.id_vehicule,
    v.num_immatriculation,
    COUNT(DISTINCT p.id_parking) AS nb_parkings_distincts
FROM stationnement s
JOIN place pl   ON s.id_place = pl.id_place
JOIN parking p  ON pl.id_parking = p.id_parking
JOIN vehicule v ON s.id_vehicule = v.id_vehicule
WHERE s.date_debut <= :'date_jour'::date
  AND s.date_fin   >= :'date_jour'::date
GROUP BY v.id_vehicule, v.num_immatriculation
HAVING COUNT(DISTINCT p.id_parking) >= 2
ORDER BY v.num_immatriculation;


-- =========  Vehicule appartenant a un utilisateur : :id_utilisateur =========
SELECT * 
FROM vehicule 
WHERE id_utilisateur = :id_utilisateur;
-- =========  Abonnement d'un Utilisateur :id_utilisateur =========
SELECT ab.* 
FROM abonnement ab
JOIN posseder_au pau ON ab.id_abonnement = pau.id_abonnement
WHERE pau.id_utilisateur = :id_utilisateur;
-- =========  Compte d'un Utilisateur :id_utilisateur =========
SELECT * 
FROM compte 
WHERE id_utilisateur = :id_utilisateur;
-- =========  Liste des abonnements d'une Vehicule :id_vehicule =========
SELECT ab.* 
FROM abonnement ab
JOIN posseder_av pav ON ab.id_abonnement = pav.id_abonnement
WHERE pav.id_vehicule = :id_vehicule;

-- =========  Tarif d'une Place :id_place =========
SELECT t.*
FROM place p
JOIN appliquer a ON p.id_parking = a.id_parking AND p.id_categorie_place = a.id_categorie_place
JOIN tarif t ON a.id_tarif = t.id_tarif
WHERE p.id_place = :id_place;

-- =========  liste des abonnements proposés par un Parking :id_parking =========
SELECT ab.* 
FROM abonnement ab
JOIN proposer_auv pauv ON ab.id_abonnement = pauv.id_abonnement
WHERE pauv.id_parking = :id_parking;

-- =========  liste des créneaux d'un Tarif :id_tarif =========
SELECT c.* 
FROM creneau c
JOIN diviser d ON c.id_creneau = d.id_creneau
WHERE d.id_tarif = :id_tarif
ORDER BY c.debut_creneau;





-- =========  Statistiques : Moyenne du nombre de places disponibles par parking à :'instant_ts' =========
WITH stationnements_intervalles AS (
    SELECT
        s.id_stationnement,
        s.id_place,
        (s.date_debut::timestamp + s.heure_debut::time) AS ts_debut,
        (s.date_fin::timestamp + s.heure_fin::time) AS ts_fin
    FROM stationnement s
),
places_occupees AS (
    SELECT DISTINCT si.id_place
    FROM stationnements_intervalles si
    WHERE :'instant_ts'::timestamp >= si.ts_debut
      AND :'instant_ts'::timestamp < si.ts_fin
),
places_disponibles AS (
    SELECT pl.id_parking, COUNT(*) AS nb_places_disponibles
    FROM place pl
    WHERE NOT EXISTS (
        SELECT 1 FROM places_occupees po WHERE po.id_place = pl.id_place
    )
    GROUP BY pl.id_parking
)
SELECT AVG(nb_places_disponibles)::NUMERIC(10,2) AS moyenne_places_disponibles
FROM places_disponibles;

-- =========  Statistiques : Durée moyenne de stationnement d’un véhicule par parking =========
WITH durees AS (
    SELECT
        pl.id_parking,
        EXTRACT(EPOCH FROM (COALESCE(s.date_fin, CURRENT_DATE)::timestamp + COALESCE(s.heure_fin::time, '23:59:59'::time))
              - (s.date_debut::timestamp + s.heure_debut::time)) / 3600 AS duree_heures
    FROM stationnement s
    JOIN place pl ON s.id_place = pl.id_place
)
SELECT
    id_parking,
    ROUND(AVG(duree_heures),2) AS duree_moyenne_heures
FROM durees
GROUP BY id_parking
ORDER BY id_parking;

-- =========  Statistiques : Coût moyen du stationnement par véhicule par mois =========
-- Hypothèse : prix = tarif du creneau associé au tarif appliqué à la place
WITH stationnements_creneaux AS (
    SELECT
        s.id_stationnement,
        s.id_vehicule,
        s.id_place,
        EXTRACT(MONTH FROM s.date_debut) AS mois,
        EXTRACT(YEAR FROM s.date_debut) AS annee,
        c.prix
    FROM stationnement s
    JOIN place p ON s.id_place = p.id_place
    JOIN appliquer a ON p.id_parking = a.id_parking AND p.id_categorie_place = a.id_categorie_place
    JOIN tarif t ON a.id_tarif = t.id_tarif
    JOIN diviser d ON t.id_tarif = d.id_tarif
    JOIN creneau c ON d.id_creneau = c.id_creneau
)
SELECT
    id_vehicule,
    annee,
    mois,
    ROUND(SUM(prix),2) AS cout_moyen_mensuel
FROM stationnements_creneaux
GROUP BY id_vehicule, annee, mois
ORDER BY id_vehicule, annee, mois;

-- =========  Classement des parkings les moins utilisés =========
WITH occupation AS (
    SELECT
        pl.id_parking,
        COUNT(s.id_stationnement) AS nb_stationnements
    FROM place pl
    LEFT JOIN stationnement s ON pl.id_place = s.id_place
    GROUP BY pl.id_parking
)
SELECT
    p.id_parking,
    p.nom_parking,
    COALESCE(o.nb_stationnements,0) AS nb_stationnements
FROM parking p
LEFT JOIN occupation o ON p.id_parking = o.id_parking
ORDER BY nb_stationnements ASC;

-- =========  Classement des parkings les plus rentables par commune et par mois =========
WITH revenus AS (
    SELECT
        pl.id_parking,
        c.id_commune,
        EXTRACT(YEAR FROM s.date_debut) AS annee,
        EXTRACT(MONTH FROM s.date_debut) AS mois,
        SUM(cr.prix) AS revenu_mensuel
    FROM stationnement s
    JOIN place pl ON s.id_place = pl.id_place
    JOIN parking p ON pl.id_parking = p.id_parking
    JOIN commune c ON p.id_commune = c.id_commune
    JOIN appliquer a ON pl.id_parking = a.id_parking AND pl.id_categorie_place = a.id_categorie_place
    JOIN tarif t ON a.id_tarif = t.id_tarif
    JOIN diviser d ON t.id_tarif = d.id_tarif
    JOIN creneau cr ON d.id_creneau = cr.id_creneau
    GROUP BY pl.id_parking, c.id_commune, annee, mois
)
SELECT
    id_commune,
    id_parking,
    annee,
    mois,
    ROUND(revenu_mensuel,2) AS revenu_mensuel
FROM revenus
ORDER BY id_commune, revenu_mensuel DESC;

-- =========  Classement des communes les plus demandées par semaine =========
WITH stationnements_semaine AS (
    SELECT
        c.id_commune,
        EXTRACT(WEEK FROM s.date_debut) AS semaine,
        COUNT(s.id_stationnement) AS nb_stationnements
    FROM stationnement s
    JOIN place pl ON s.id_place = pl.id_place
    JOIN parking p ON pl.id_parking = p.id_parking
    JOIN commune c ON p.id_commune = c.id_commune
    GROUP BY c.id_commune, semaine
)
SELECT
    id_commune,
    semaine,
    nb_stationnements
FROM stationnements_semaine
ORDER BY semaine, nb_stationnements DESC;
