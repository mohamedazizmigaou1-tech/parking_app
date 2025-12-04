-- ============================================================
--   Table : Commune                                            
-- ============================================================
CREATE TABLE commune (
    id_commune SERIAL PRIMARY KEY,
    code_postal INTEGER,
    nom_commune VARCHAR(255)
);

-- ============================================================
--   Table : Parking                                            
-- ============================================================
CREATE TABLE parking (
    id_parking SERIAL PRIMARY KEY,
    nom_parking VARCHAR(255),
    type_parking VARCHAR(255),
    adresse VARCHAR(255),
    capacite INTEGER,
    id_commune INTEGER NOT NULL,
    CONSTRAINT fk_parking_commune FOREIGN KEY(id_commune) REFERENCES commune(id_commune)
);

-- ============================================================
--   Table : Catégorie place                                            
-- ============================================================
CREATE TYPE genre_type AS ENUM ('Voiture', 'Moto', 'Electrique', 'Van');

CREATE TABLE categorie_place (
    id_categorie_place SERIAL PRIMARY KEY,
    type_place genre_type
);

-- ============================================================
--   Table : Place                                            
-- ============================================================
CREATE TABLE place (
    id_place SERIAL PRIMARY KEY,
    num_place VARCHAR(255),
    etat_place VARCHAR(255),
    id_parking INTEGER NOT NULL,
    id_categorie_place INTEGER NOT NULL,
    CONSTRAINT fk_place_parking FOREIGN KEY(id_parking) REFERENCES parking(id_parking),
    CONSTRAINT fk_place_categorie_place FOREIGN KEY(id_categorie_place) REFERENCES categorie_place(id_categorie_place)
);

-- ============================================================
--   Table : Utilisateur                                            
-- ============================================================
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    p_identite VARCHAR(255)
);

-- ============================================================
--   Table : Véhicule                                            
-- ============================================================
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    num_immatriculation VARCHAR(255), 
    marque_vehicule VARCHAR(255),
    genre_vehicule genre_type,
    date_de_fabrication DATE,
    etat_vehicule VARCHAR(255),
    kilometrage INTEGER,
    id_utilisateur INTEGER NOT NULL,
    CONSTRAINT fk_vehicule_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- ============================================================
--   Table : Abonnement                                            
-- ============================================================
CREATE TYPE genre_abonnement AS ENUM ('AU','AV');

CREATE TABLE abonnement (
    id_abonnement SERIAL PRIMARY KEY,
    date_debut_abonnement DATE,
    date_fin_abonnement DATE,
    type_abonnement genre_abonnement,
    tarif_mensuel_abonnement FLOAT
);
-- CONSTRAINT fk_abonnement_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule)

-- ============================================================
--   Table : Posséder AV                                           
-- ============================================================
CREATE TABLE posseder_av (
    id_vehicule INTEGER NOT NULL,
    id_abonnement INTEGER NOT NULL,
    CONSTRAINT fk_posseder_au_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule),
    CONSTRAINT fk_posseder_au_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    PRIMARY KEY (id_vehicule, id_abonnement)
);

-- ============================================================
--   Table : Posséder AU                                      
-- ============================================================
CREATE TABLE posseder_au (
    id_utilisateur INTEGER NOT NULL,
    id_abonnement INTEGER NOT NULL,
    CONSTRAINT fk_posseder_au_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT fk_posseder_au_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    PRIMARY KEY (id_utilisateur, id_abonnement)
);

-- ============================================================
--   Table : Stationnement                                            
-- ============================================================
CREATE TABLE stationnement (
    id_stationnement SERIAL PRIMARY KEY,
    date_debut DATE,
    date_fin DATE,
    heure_debut VARCHAR(255),
    heure_fin VARCHAR(255),
    mode_paiement VARCHAR(255),
    id_vehicule INTEGER NOT NULL,
    id_place INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    CONSTRAINT fk_stationnement_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule),
    CONSTRAINT fk_stationnement_place FOREIGN KEY(id_place) REFERENCES place(id_place),
    CONSTRAINT fk_stationnement_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- ============================================================
--   Table : Tarif                                            
-- ============================================================
CREATE TABLE tarif (
    id_tarif SERIAL PRIMARY KEY
);

-- ============================================================
--   Table : Creneau                                            
-- ============================================================
CREATE TABLE creneau (
    id_creneau SERIAL PRIMARY KEY,
    prix FLOAT,
    debut_creneau VARCHAR(255), -- distance in minutes/seconds from midnight !!!
    fin_creneau VARCHAR(255)
);

-- ============================================================
--   Table : Diviser                                            
-- ============================================================
CREATE TABLE diviser (
    id_creneau INTEGER REFERENCES creneau(id_creneau),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_creneau,id_tarif)
);

-- ============================================================
--   Table : Compte                                            
-- ============================================================
CREATE TABLE compte (
    id_compte SERIAL PRIMARY KEY,
    identifiant VARCHAR(255),
    mot_de_passe VARCHAR(255),
    date_creation DATE,
    id_utilisateur INTEGER NOT NULL,
    CONSTRAINT fk_compte_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- ============================================================
--   Table : Appliquer                                            
-- ============================================================
CREATE TABLE appliquer (
    id_parking INTEGER REFERENCES parking(id_parking),
    id_categorie_place INTEGER REFERENCES categorie_place(id_categorie_place),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_parking, id_categorie_place)
);

-- ============================================================
--   Table : Proposer A[UV]                                         
-- ============================================================
CREATE TABLE proposer_auv (
    id_abonnement INTEGER PRIMARY KEY NOT NULL,
    id_parking INTEGER NOT NULL,
    CONSTRAINT fk_proposer_au_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    CONSTRAINT fk_proposer_au_parking FOREIGN KEY(id_parking) REFERENCES parking(id_parking)
);