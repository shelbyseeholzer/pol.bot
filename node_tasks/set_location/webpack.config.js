const path = require('path');

module.exports = {
    entry: './index.js', // Path to your main JavaScript file
    output: {
        filename: 'bundle.js', // Bundled file
        path: path.resolve(__dirname, 'dist'), // Output directory
    },
    mode: 'production',
};
