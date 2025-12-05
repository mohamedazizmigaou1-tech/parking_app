-- ============================================================
--   INSERT DATA FOR COMMUNE TABLE
-- ============================================================
INSERT INTO commune (id_commune, code_postal, nom_commune) VALUES
(1, 75001, 'Paris 1er'),
(2, 75002, 'Paris 2ème'),
(3, 75003, 'Paris 3ème'),
(4, 69001, 'Lyon 1er'),
(5, 69002, 'Lyon 2ème'),
(6, 13001, 'Marseille 1er'),
(7, 13002, 'Marseille 2ème'),
(8, 33000, 'Bordeaux'),
(9, 34000, 'Montpellier'),
(10, 31000, 'Toulouse');

-- ============================================================
--   INSERT DATA FOR PARKING TABLE
-- ============================================================
INSERT INTO parking (id_parking, nom_parking, type_parking, adresse, capacite, id_commune) VALUES
(1, 'Parking Concorde', 'Souterrain', 'Place de la Concorde', 500, 1),
(2, 'Parking Bourse', 'Aérien', 'Rue Vivienne', 300, 2),
(3, 'Parking République', 'Souterrain', 'Place de la République', 400, 3),
(4, 'Parking Bellecour', 'Souterrain', 'Place Bellecour', 350, 4),
(5, 'Parking Perrache', 'Mixte', 'Place Carnot', 600, 4),
(6, 'Parking Vieux Port', 'Aérien', 'Quai du Port', 250, 6),
(7, 'Parking Gambetta', 'Souterrain', 'Avenue Gambetta', 200, 8),
(8, 'Parking Comédie', 'Souterrain', 'Place de la Comédie', 450, 9),
(9, 'Parking Capitole', 'Aérien', 'Place du Capitole', 320, 10),
(10, 'Parking Wilson', 'Souterrain', 'Place Wilson', 280, 10);

-- ============================================================
--   INSERT DATA FOR CATEGORIE_PLACE TABLE
-- ============================================================
INSERT INTO categorie_place (id_categorie_place, type_place) VALUES
(1, 'Voiture'),
(2, 'Moto'),
(3, 'Electrique'),
(4, 'Van');

-- ============================================================
--   INSERT DATA FOR PLACE TABLE
-- ============================================================
INSERT INTO place (id_place, num_place, etat_place, id_parking, id_categorie_place) VALUES
(1, 'A01', 'Libre', 1, 1),
(2, 'A02', 'Occupée', 1, 1),
(3, 'A03', 'Réservée', 1, 1),
(4, 'B01', 'Libre', 1, 2),
(5, 'B02', 'Occupée', 1, 2),
(6, 'C01', 'Libre', 1, 3),
(7, 'C02', 'Hors service', 1, 3),
(8, 'D01', 'Libre', 1, 4),
(9, 'A10', 'Libre', 2, 1),
(10, 'A11', 'Occupée', 2, 1),
(11, 'B10', 'Libre', 2, 2),
(12, 'C10', 'Libre', 2, 3),
(13, 'A20', 'Libre', 3, 1),
(14, 'A21', 'Occupée', 3, 1),
(15, 'E01', 'Libre', 4, 1),
(16, 'F01', 'Libre', 5, 1),
(17, 'G01', 'Libre', 6, 1),
(18, 'H01', 'Libre', 7, 1),
(19, 'I01', 'Libre', 8, 1),
(20, 'J01', 'Libre', 9, 1);

-- ============================================================
--   INSERT DATA FOR UTILISATEUR TABLE
-- ============================================================
INSERT INTO utilisateur (id_utilisateur, p_identite) VALUES
(1, 'AB123456'),
(2, 'CD789012'),
(3, 'EF345678'),
(4, 'GH901234'),
(5, 'IJ567890'),
(6, 'KL123456'),
(7, 'MN789012'),
(8, 'OP345678'),
(9, 'QR901234'),
(10, 'ST567890');

-- ============================================================
--   INSERT DATA FOR VEHICULE TABLE
-- ============================================================
INSERT INTO vehicule (id_vehicule, num_immatriculation, marque_vehicule,genre_vehicule, date_de_fabrication, etat_vehicule, kilometrage, id_utilisateur) VALUES
(1, 'AB-123-CD', 'Renault','Voiture', '2020-05-15', 'Bon', 25000, 1),
(2, 'EF-456-GH', 'Peugeot','Voiture', '2019-03-20', 'Bon', 35000, 2),
(3, 'IJ-789-KL', 'BMW','Moto', '2021-01-10', 'Excellent', 12000, 3),
(4, 'MN-012-OP', 'Toyota','Voiture', '2018-07-30', 'Moyen', 55000, 4),
(5, 'QR-345-ST', 'Tesla','Electrique', '2022-02-15', 'Excellent', 8000, 5),
(6, 'UV-678-WX', 'Yamaha','Moto', '2020-09-25', 'Bon', 15000, 6),
(7, 'YZ-901-AB', 'Mercedes','Voiture', '2019-11-12', 'Bon', 28000, 7),
(8, 'CD-234-EF', 'Volkswagen','Voiture', '2017-06-18', 'Moyen', 72000, 8),
(9, 'GH-567-IJ', 'Ducati','Moto', '2021-08-05', 'Excellent', 9000, 9),
(10, 'KL-890-MN', 'Ford','Voiture', '2018-12-22', 'Bon', 48000, 10);

-- ============================================================
--   INSERT DATA FOR ABONNEMENT TABLE
-- ============================================================
INSERT INTO abonnement (id_abonnement, date_debut_abonnement, date_fin_abonnement, type_abonnement, tarif_mensuel_abonnement) VALUES
(1, '2024-01-01', '2024-12-31', 'AU', 80.00),
(2, '2024-03-01', '2025-02-28', 'AU', 85.00),
(3, '2024-01-15', '2024-07-14', 'AV', 45.00),
(4, '2024-02-01', '2024-08-01', 'AU', 75.00),
(5, '2024-04-01', '2024-10-01', 'AV', 50.00),
(6, '2024-01-01', '2024-06-30', 'AU', 90.00),
(7, '2024-03-15', '2024-09-15', 'AV', 55.00),
(8, '2024-02-15', '2024-11-15', 'AU', 70.00),
(9, '2024-01-20', '2024-12-20', 'AV', 60.00),
(10, '2024-05-01', '2024-11-01', 'AU', 65.00);

-- ============================================================
--   INSERT DATA FOR POSSEDER_AU TABLE
-- ============================================================
INSERT INTO posseder_au (id_utilisateur, id_abonnement) VALUES
(1, 1),
(3, 2),
(4, 3),
(7, 4),
(8, 5),
(10, 6);

-- ============================================================
--   INSERT DATA FOR POSSEDER_AV TABLE
-- ============================================================
INSERT INTO posseder_av (id_vehicule, id_abonnement) VALUES
(2, 7),
(6, 8),
(9, 9),
(5, 10);

-- ============================================================
--   INSERT DATA FOR STATIONNEMENT TABLE
-- ============================================================
INSERT INTO stationnement (id_stationnement, date_debut, date_fin, heure_debut, heure_fin, mode_paiement, id_vehicule, id_place, id_utilisateur) VALUES
(1, '2024-05-10', '2024-05-10', '08:30', '18:15', 'Carte', 1, 1, 1),
(2, '2024-05-11', '2024-05-11', '09:00', '17:45', 'Espèces', 2, 9, 2),
(3, '2024-05-12', '2024-05-12', '10:15', '15:30', 'Carte', 3, 13, 3),
(4, '2024-05-13', '2024-05-13', '14:00', '20:00', 'Mobile', 4, 15, 4),
(5, '2024-05-14', '2024-05-14', '07:45', '19:20', 'Carte', 5, 12, 5),
(6, '2024-05-15', '2024-05-15', '11:30', '16:45', 'Espèces', 6, 11, 6),
(7, '2024-05-16', '2024-05-16', '13:15', '22:00', 'Carte', 7, 16, 7),
(8, '2024-05-17', '2024-05-17', '08:00', '12:30', 'Mobile', 8, 18, 8),
(9, '2024-05-18', '2024-05-18', '16:00', '20:15', 'Carte', 9, 19, 9),
(10, '2024-05-19', '2024-05-19', '12:00', '18:45', 'Espèces', 10, 20, 10);

-- ============================================================
--   INSERT DATA FOR TARIF TABLE (Now only has ID)
-- ============================================================
INSERT INTO tarif (id_tarif) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- ============================================================
--   INSERT DATA FOR CRENEAU TABLE (Time intervals with prices)
-- ============================================================
INSERT INTO creneau (id_creneau, prix, debut_creneau, fin_creneau) VALUES
(1, 3.00, '08:00', '18:00'),
(2, 1.50, '18:00', '08:00'),

(3, 1.50, '08:00', '12:00'),
(4, 2.00, '12:00', '18:00'),
(5, 1.00, '18:00', '08:00'),

(6, 2.00, '07:00', '19:00'),
(7, 1.00, '19:00', '07:00'),

(8, 4.00, '06:00', '20:00'),
(9, 2.00, '20:00', '06:00'),

(10, 3.50, '07:00', '12:00'),
(11, 4.00, '12:00', '19:00'),
(12, 2.00, '19:00', '07:00'),

(13, 1.80, '08:00', '18:00'),
(14, 1.00, '18:00', '08:00'),

(15, 1.50, '00:00', '24:00'), 

(16, 2.80, '06:00', '10:00'),
(17, 3.20, '10:00', '17:00'),
(18, 2.20, '17:00', '06:00'),

(19, 3.00, '07:00', '19:00'),
(20, 1.80, '19:00', '07:00'),

(21, 4.00, '06:00', '22:00'),
(22, 2.20, '22:00', '06:00');

-- ============================================================
--   INSERT DATA FOR DIVISER TABLE (Links creneaux to tarifs)
-- ============================================================
INSERT INTO diviser (id_creneau, id_tarif) VALUES
-- Tarif 1 has creneaux 1 and 2
(1, 1),
(2, 1),

-- Tarif 2 has creneaux 3, 4, and 5
(3, 2),
(4, 2),
(5, 2),

-- Tarif 3 has creneaux 6 and 7
(6, 3),
(7, 3),

-- Tarif 4 has creneaux 8 and 9
(8, 4),
(9, 4),

-- Tarif 5 has creneaux 10, 11, and 12
(10, 5),
(11, 5),
(12, 5),

-- Tarif 6 has creneaux 13 and 14
(13, 6),
(14, 6),

-- Tarif 7 has creneau 15 (24/7 flat rate)
(15, 7),

-- Tarif 8 has creneaux 16, 17, and 18
(16, 8),
(17, 8),
(18, 8),

-- Tarif 9 has creneaux 19 and 20
(19, 9),
(20, 9),

-- Tarif 10 has creneaux 21 and 22
(21, 10),
(22, 10);

-- ============================================================
--   INSERT DATA FOR COMPTE TABLE
-- ============================================================
INSERT INTO compte (id_compte, identifiant, mot_de_passe, date_creation, id_utilisateur) VALUES
(1, 'jean.dupont', 'password123', '2023-01-15', 1),
(2, 'marie.martin', 'securepass', '2023-02-20', 2),
(3, 'pierre.durand', 'pierre2023', '2023-03-10', 3),
(4, 'sophie.leroy', 'sophiepass', '2023-04-05', 4),
(5, 'luc.berger', 'luc123456', '2023-05-12', 5),
(6, 'anne.petit', 'annepass789', '2023-06-18', 6),
(7, 'thomas.moreau', 'thomaspass', '2023-07-22', 7),
(8, 'julie.roux', 'julie2023', '2023-08-30', 8),
(9, 'marc.vincent', 'marcpass', '2023-09-14', 9),
(10, 'elise.simon', 'elisepass123', '2023-10-25', 10);

-- ============================================================
--   INSERT DATA FOR APPLIQUER TABLE (Links parking, category, and tarif)
-- ============================================================
INSERT INTO appliquer (id_parking, id_categorie_place, id_tarif) VALUES
(1, 1, 1),  -- Parking 1, Voiture -> Tarif 1
(1, 2, 2),  -- Parking 1, Moto -> Tarif 2
(1, 3, 3),  -- Parking 1, Electrique -> Tarif 3
(1, 4, 4),  -- Parking 1, Van -> Tarif 4
(2, 1, 5),  -- Parking 2, Voiture -> Tarif 5
(2, 2, 6),  -- Parking 2, Moto -> Tarif 6
(2, 3, 7),  -- Parking 2, Electrique -> Tarif 7
(3, 1, 8),  -- Parking 3, Voiture -> Tarif 8
(4, 1, 9),  -- Parking 4, Voiture -> Tarif 9
(5, 1, 10); -- Parking 5, Voiture -> Tarif 10

-- ============================================================
--   INSERT DATA FOR PROPOSER_AUV TABLE
-- ============================================================
INSERT INTO proposer_auv (id_abonnement, id_parking) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- ============================================================
--   RESET SEQUENCES AFTER INSERTING DATA
-- ============================================================
-- Reset all serial sequences to start after the last inserted ID

SELECT setval('commune_id_commune_seq', (SELECT MAX(id_commune) FROM commune));

SELECT setval('parking_id_parking_seq', (SELECT MAX(id_parking) FROM parking));

SELECT setval('categorie_place_id_categorie_place_seq', (SELECT MAX(id_categorie_place) FROM categorie_place));

SELECT setval('place_id_place_seq', (SELECT MAX(id_place) FROM place));

SELECT setval('utilisateur_id_utilisateur_seq', (SELECT MAX(id_utilisateur) FROM utilisateur));

SELECT setval('vehicule_id_vehicule_seq', (SELECT MAX(id_vehicule) FROM vehicule));

SELECT setval('abonnement_id_abonnement_seq', (SELECT MAX(id_abonnement) FROM abonnement));

SELECT setval('stationnement_id_stationnement_seq', (SELECT MAX(id_stationnement) FROM stationnement));

SELECT setval('tarif_id_tarif_seq', (SELECT MAX(id_tarif) FROM tarif));

SELECT setval('creneau_id_creneau_seq', (SELECT MAX(id_creneau) FROM creneau));

SELECT setval('compte_id_compte_seq', (SELECT MAX(id_compte) FROM compte));

-- Note: For tables without serial IDs (posseder_au, posseder_av, diviser, appliquer, proposer_auv)
-- No sequence reset needed as they don't have auto-incrementing IDs