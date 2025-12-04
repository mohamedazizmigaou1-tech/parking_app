class AuthManager {
    constructor() {
        this.currentUser = null;
        this.init();
    }

    init() {
        // Check if user is already logged in
        const savedUser = localStorage.getItem('parkingUser');
        if (savedUser) {
            this.currentUser = JSON.parse(savedUser);
            this.showDashboard();
        }

        // Login form handler
        const loginForm = document.getElementById('login-form');
        if (loginForm) {
            loginForm.addEventListener('submit', (e) => this.handleLogin(e));
        }

        // Logout handler
        const logoutBtn = document.getElementById('logout-btn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => this.logout());
        }
    }

    async handleLogin(e) {
        e.preventDefault();
        
        const identification = document.getElementById('identification').value;
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const errorDiv = document.getElementById('login-error');

        try {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ identification, username, password })
            });

            const data = await response.json();

            if (data.success) {
                this.currentUser = {
                    id: data.userId,
                    identification: data.identification,
                    username: username
                };
                
                // Save to localStorage
                localStorage.setItem('parkingUser', JSON.stringify(this.currentUser));
                
                // Show dashboard
                this.showDashboard();
                
                Utils.showNotification('Connexion réussie!', 'success');
            } else {
                errorDiv.textContent = data.error || 'Erreur de connexion';
                errorDiv.style.display = 'block';
            }
        } catch (error) {
            errorDiv.textContent = 'Erreur serveur';
            errorDiv.style.display = 'block';
            console.error('Login error:', error);
        }
    }

    showDashboard() {
        document.getElementById('login-screen').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';
        
        if (this.currentUser) {
            document.getElementById('current-user').textContent = 
                `Utilisateur: ${this.currentUser.username} (ID: ${this.currentUser.id})`;
        }
    }

    logout() {
        this.currentUser = null;
        localStorage.removeItem('parkingUser');
        
        document.getElementById('dashboard').style.display = 'none';
        document.getElementById('login-screen').style.display = 'block';
        
        // Reset login form
        document.getElementById('login-form').reset();
        document.getElementById('login-error').style.display = 'none';
        
        Utils.showNotification('Déconnexion réussie', 'info');
    }

    getCurrentUser() {
        return this.currentUser;
    }
}

// Initialize auth manager
const authManager = new AuthManager();