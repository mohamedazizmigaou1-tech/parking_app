// Utility functions
const Utils = {
    // Format date
    formatDate: (date) => {
        return new Date(date).toLocaleDateString('fr-FR');
    },

    // Format datetime
    formatDateTime: (datetime) => {
        return new Date(datetime).toLocaleString('fr-FR');
    },

    // Generate CSV from data
    generateCSV: (data, headers) => {
        if (!data || data.length === 0) return '';
        
        const csvRows = [];
        
        // Add headers
        if (headers) {
            csvRows.push(headers.join(','));
        } else {
            const header = Object.keys(data[0]).join(',');
            csvRows.push(header);
        }
        
        // Add data rows
        for (const row of data) {
            const values = Object.values(row).map(value => {
                if (value === null || value === undefined) return '';
                const stringValue = String(value);
                return `"${stringValue.replace(/"/g, '""')}"`;
            });
            csvRows.push(values.join(','));
        }
        
        return csvRows.join('\n');
    },

    // Download CSV
    downloadCSV: (csvContent, filename) => {
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = filename;
        link.click();
    },

    // Show notification
    showNotification: (message, type = 'info') => {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            background: ${type === 'error' ? '#e74c3c' : type === 'success' ? '#2ecc71' : '#3498db'};
            color: white;
            border-radius: 5px;
            z-index: 1000;
            animation: slideIn 0.3s ease;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
};

// Add CSS for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);