class UIManager {
    constructor() {
        this.init();
    }

    init() {
        // Query button handlers
        document.querySelectorAll('.query-btn').forEach(button => {
            button.addEventListener('click', (e) => this.handleQueryButton(e));
        });
    }

    async handleQueryButton(e) {
        const button = e.currentTarget;
        const queryType = button.dataset.query;
        
        // Show loading state
        button.disabled = true;
        const originalText = button.textContent;
        button.textContent = 'Chargement...';

        try {
            await this.executeQuery(queryType);
        } finally {
            // Restore button state
            button.disabled = false;
            button.textContent = originalText;
        }
    }

    async executeQuery(queryType) {
        const currentUser = authManager.getCurrentUser();
        let url = `/api/queries/${queryType}`;
        let params = {};

        // Handle different query types
        switch(queryType) {
            case 'parkings-satures-jour':
                params.date = document.getElementById('param-date').value;
                break;
            case 'parkings-satures-instant':
            case 'places-disponibles':
                params.instant = document.getElementById('param-instant').value;
                break;
            case 'vehicules-multi-parkings':
                params.date = document.getElementById('param-date').value;
                break;
            case 'mes-vehicules':
            case 'mes-abonnements':
            case 'mon-compte':
                if (!currentUser) {
                    Utils.showNotification('Veuillez vous connecter', 'error');
                    return;
                }
                url += `/${currentUser.id}`;
                break;
            case 'abonnements-vehicule':
                const vehiculeId = document.getElementById('vehicule-id').value;
                if (!vehiculeId) {
                    Utils.showNotification('Veuillez entrer un ID véhicule', 'error');
                    return;
                }
                url += `/${vehiculeId}`;
                break;
            case 'tarif-place':
                const placeId = document.getElementById('place-id').value;
                if (!placeId) {
                    Utils.showNotification('Veuillez entrer un ID place', 'error');
                    return;
                }
                url += `/${placeId}`;
                break;
            case 'abonnements-parking':
                const parkingId = document.getElementById('parking-id').value;
                if (!parkingId) {
                    Utils.showNotification('Veuillez entrer un ID parking', 'error');
                    return;
                }
                url += `/${parkingId}`;
                break;
            case 'creneaux-tarif':
                const tarifId = document.getElementById('tarif-id').value;
                if (!tarifId) {
                    Utils.showNotification('Veuillez entrer un ID tarif', 'error');
                    return;
                }
                url += `/${tarifId}`;
                break;
        }

        // Add query parameters if any
        if (Object.keys(params).length > 0) {
            const queryString = new URLSearchParams(params).toString();
            url += `?${queryString}`;
        }

        try {
            const response = await fetch(url);
            const result = await response.json();

            if (result.success) {
                this.displayResults(queryType, result.data);
            } else {
                Utils.showNotification(`Erreur: ${result.error}`, 'error');
            }
        } catch (error) {
            console.error('Query execution error:', error);
            Utils.showNotification('Erreur serveur', 'error');
        }
    }

    displayResults(queryType, data) {
        const queryTitles = {
            'voitures-par-parking': 'Voitures par parking',
            'parkings-par-commune': 'Parkings par commune',
            'parkings-satures-jour': 'Parkings saturés (date spécifique)',
            'parkings-satures-instant': 'Parkings saturés (instant spécifique)',
            'places-disponibles': 'Places disponibles',
            'vehicules-multi-parkings': 'Véhicules dans multiple parkings',
            'mes-vehicules': 'Mes véhicules',
            'mes-abonnements': 'Mes abonnements',
            'mon-compte': 'Mon compte',
            'abonnements-vehicule': 'Abonnements du véhicule',
            'tarif-place': 'Tarif de la place',
            'abonnements-parking': 'Abonnements proposés par le parking',
            'creneaux-tarif': 'Créneaux du tarif'
        };

        // Update title
        document.getElementById('current-query-title').textContent = queryTitles[queryType] || queryType;
        
        // Display query info
        const queryInfo = document.getElementById('query-info');
        queryInfo.innerHTML = `
            <strong>Nombre d'enregistrements:</strong> ${data.length}<br>
            <strong>Type de requête:</strong> ${queryTitles[queryType] || queryType}<br>
            <strong>Date d'exécution:</strong> ${new Date().toLocaleString('fr-FR')}
        `;

        // Display table
        const resultsTable = document.getElementById('results-table');
        
        if (data.length === 0) {
            resultsTable.innerHTML = '<div class="no-data">Aucun résultat trouvé</div>';
            return;
        }

        // Create table
        let html = '<table><thead><tr>';
        
        // Add headers
        const headers = Object.keys(data[0]);
        headers.forEach(header => {
            html += `<th>${this.formatHeader(header)}</th>`;
        });
        html += '</tr></thead><tbody>';

        // Add rows
        data.forEach(row => {
            html += '<tr>';
            headers.forEach(header => {
                const value = row[header];
                html += `<td>${this.formatCell(value, header)}</td>`;
            });
            html += '</tr>';
        });

        html += '</tbody></table>';
        resultsTable.innerHTML = html;
    }

    formatHeader(header) {
        return header
            .replace(/_/g, ' ')
            .split(' ')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1))
            .join(' ');
    }

    formatCell(value, header) {
        if (value === null || value === undefined) return '-';
        
        // Format based on header name
        if (header.includes('date')) {
            return Utils.formatDate(value);
        }
        if (header.includes('heure') || header.includes('debut') || header.includes('fin')) {
            return value;
        }
        if (typeof value === 'number') {
            return new Intl.NumberFormat('fr-FR').format(value);
        }
        
        return value;
    }
}

// Initialize UI manager
const uiManager = new UIManager();