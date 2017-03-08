var ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: [
    './web/static/js/index.js',
    './web/static/css/app.scss'
  ],
  output: {
    path: "./priv/static",
    filename: "js/app.js",
    publicPath: "/"
  },
  module: {
    loaders: [
      {
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['react', 'es2015', 'stage-2', 'es2017']
        }
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({ fallback: "style-loader", use: "css-loader" })
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract({ fallback: "style-loader", use: "css-loader!sass-loader" })
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx', '.scss'],
    alias: {
      phoenix: __dirname + '/deps/phoenix/web/static/js/phoenix.js'
    }
  },
  plugins: [
    new ExtractTextPlugin('css/app.css')
  ]
};
