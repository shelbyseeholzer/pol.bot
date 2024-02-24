const path = require('path');

module.exports = {
    mode: 'development', // Use 'production' for production builds
    entry: './app/javascript/packs/index.js', // Path to your entry file
    output: {
        filename: 'bundle.js', // Output bundle file name
        path: path.resolve(__dirname, 'app/assets/javascripts'), // Output path for Rails asset pipeline
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                    },
                },
            },
        ],
    },
};
