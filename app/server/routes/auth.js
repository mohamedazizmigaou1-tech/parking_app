const express = require('express');
const router = express.Router();
const db = require('../database');

// Register/Login user
router.post('/login', async (req, res) => {
    const { identification, username, password } = req.body;
    
    try {
        // Check if user exists
        const userCheck = await db.query(
            'SELECT * FROM utilisateur WHERE p_identite = $1',
            [identification]
        );
        
        let userId;
        
        if (userCheck.rows.length === 0) {
            // Create new user
            const newUser = await db.query(
                'INSERT INTO utilisateur (p_identite) VALUES ($1) RETURNING id_utilisateur',
                [identification]
            );
            userId = newUser.rows[0].id_utilisateur;
            
            // Create account
            await db.query(
                'INSERT INTO compte (identifiant, mot_de_passe, date_creation, id_utilisateur) VALUES ($1, $2, CURRENT_DATE, $3)',
                [username, password, userId]
            );
            
        } else {
            userId = userCheck.rows[0].id_utilisateur;
            
            // Check if account exits
            const accountCheck = await db.query(
                'SELECT * FROM compte WHERE id_utilisateur = $1',
                [userId]
            );
            
            if (accountCheck.rows.length === 0) {
                // Create account
                await db.query(
                    'INSERT INTO compte (identifiant, mot_de_passe, date_creation, id_utilisateur) VALUES ($1, $2, CURRENT_DATE, $3)',
                    [username, password, userId]
                );
            }
            else{
                // Check if correct password
                const pwdCheck = await db.query(
                    'SELECT * FROM compte WHERE id_utilisateur = $1 AND mot_de_passe = $2',
                    [userId, password]
                );

                if (pwdCheck.rows.length === 0) {
                    return res.status(401).json({ error: 'wrong password' });
                }

            }
        }
        
        res.json({ 
            success: true, 
            userId: userId,
            identification: identification 
        });
        
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;