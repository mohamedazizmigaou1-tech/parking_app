const express = require('express');
const router = express.Router();
const db = require('../database');

// Helper function to execute queries
const executeQuery = async (query, params = []) => {
    try {
        const result = await db.query(query, params);
        return { success: true, data: result.rows };
    } catch (error) {
        console.error('Query error:', error);
        return { success: false, error: error.message };
    }
};

// 1. Liste des voitures par parking
router.get('/voitures-par-parking', async (req, res) => {
    const query = `
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
    `;
    const result = await executeQuery(query);
    res.json(result);
});

// 2. Liste des parkings par commune
router.get('/parkings-par-commune', async (req, res) => {
    const query = `
        SELECT
            c.id_commune,
            c.nom_commune,
            p.id_parking,
            p.nom_parking
        FROM parking p
        JOIN commune c ON p.id_commune = c.id_commune
        ORDER BY c.nom_commune, p.nom_parking;
    `;
    const result = await executeQuery(query);
    res.json(result);
});

// 3. Parkings saturés à une date donnée
router.get('/parkings-satures-jour', async (req, res) => {
    const { date } = req.query;
    const query = `
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
            WHERE s.date_debut <= $1::date
              AND s.date_fin   >= $1::date
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
    `;
    const result = await executeQuery(query, [date || '2025-12-04']);
    res.json(result);
});

// 4. Parkings saturés à l'instant
router.get('/parkings-satures-instant', async (req, res) => {
    const { instant } = req.query;
    const query = `
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
            WHERE $1::timestamp >= si.ts_debut
              AND $1::timestamp <  si.ts_fin
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
            COALESCE(op.nb_places_occupees, 0) AS nb_places_occupees
        FROM parking p
        LEFT JOIN occupation_parking op ON op.id_parking = p.id_parking
        WHERE COALESCE(op.nb_places_occupees, 0) >= p.capacite
        ORDER BY p.nom_parking;
    `;
    const result = await executeQuery(query, [instant || '2025-12-04 10:30:00']);
    res.json(result);
});

// 5. Places disponibles par parking
router.get('/places-disponibles', async (req, res) => {
    const { instant } = req.query;
    const query = `
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
            WHERE $1::timestamp >= si.ts_debut
              AND $1::timestamp < si.ts_fin
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
    `;
    const result = await executeQuery(query, [instant || '2025-12-04 10:30:00']);
    res.json(result);
});

// 6. Véhicules garés dans ≥ 2 parkings
router.get('/vehicules-multi-parkings', async (req, res) => {
    const { date } = req.query;
    const query = `
        SELECT
            v.id_vehicule,
            v.num_immatriculation,
            COUNT(DISTINCT p.id_parking) AS nb_parkings_distincts
        FROM stationnement s
        JOIN place pl   ON s.id_place = pl.id_place
        JOIN parking p  ON pl.id_parking = p.id_parking
        JOIN vehicule v ON s.id_vehicule = v.id_vehicule
        WHERE s.date_debut <= $1::date
          AND s.date_fin   >= $1::date
        GROUP BY v.id_vehicule, v.num_immatriculation
        HAVING COUNT(DISTINCT p.id_parking) >= 2
        ORDER BY v.num_immatriculation;
    `;
    const result = await executeQuery(query, [date || '2025-12-04']);
    res.json(result);
});

// 7. Véhicules appartenant à un utilisateur
router.get('/mes-vehicules/:userId', async (req, res) => {
    const { userId } = req.params;
    const query = `SELECT * FROM vehicule WHERE id_utilisateur = $1`;
    const result = await executeQuery(query, [userId]);
    res.json(result);
});

// 8. Abonnement d'un utilisateur
router.get('/mes-abonnements/:userId', async (req, res) => {
    const { userId } = req.params;
    const query = `
        SELECT ab.* 
        FROM abonnement ab
        JOIN posseder_au pau ON ab.id_abonnement = pau.id_abonnement
        WHERE pau.id_utilisateur = $1;
    `;
    const result = await executeQuery(query, [userId]);
    res.json(result);
});

// 9. Compte d'un utilisateur
router.get('/mon-compte/:userId', async (req, res) => {
    const { userId } = req.params;
    const query = `SELECT * FROM compte WHERE id_utilisateur = $1`;
    const result = await executeQuery(query, [userId]);
    res.json(result);
});

// 10. Abonnements d'un véhicule
router.get('/abonnements-vehicule/:vehiculeId', async (req, res) => {
    const { vehiculeId } = req.params;
    const query = `
        SELECT ab.* 
        FROM abonnement ab
        JOIN posseder_av pav ON ab.id_abonnement = pav.id_abonnement
        WHERE pav.id_vehicule = $1;
    `;
    const result = await executeQuery(query, [vehiculeId]);
    res.json(result);
});

// 11. Tarif d'une place
router.get('/tarif-place/:placeId', async (req, res) => {
    const { placeId } = req.params;
    const query = `
        SELECT t.*
        FROM place p
        JOIN appliquer a ON p.id_parking = a.id_parking AND p.id_categorie_place = a.id_categorie_place
        JOIN tarif t ON a.id_tarif = t.id_tarif
        WHERE p.id_place = $1;
    `;
    const result = await executeQuery(query, [placeId]);
    res.json(result);
});

// 12. Abonnements proposés par un parking
router.get('/abonnements-parking/:parkingId', async (req, res) => {
    const { parkingId } = req.params;
    const query = `
        SELECT ab.* 
        FROM abonnement ab
        JOIN proposer_auv pauv ON ab.id_abonnement = pauv.id_abonnement
        WHERE pauv.id_parking = $1;
    `;
    const result = await executeQuery(query, [parkingId]);
    res.json(result);
});

// 13. Créneaux d'un tarif
router.get('/creneaux-tarif/:tarifId', async (req, res) => {
    const { tarifId } = req.params;
    const query = `
        SELECT c.* 
        FROM creneau c
        JOIN diviser d ON c.id_creneau = d.id_creneau
        WHERE d.id_tarif = $1
        ORDER BY c.debut_creneau;
    `;
    const result = await executeQuery(query, [tarifId]);
    res.json(result);
});

module.exports = router;