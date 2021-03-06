var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: {
    scripts: "./source/javascripts/scripts.js",
    styles: "./source/stylesheets/styles.scss",
    errors: "./source/stylesheets/errors.scss"
  },
  stats: {
    errors: false,
    errorDetails: false,
    warnings: false,
    publicPath: false
  },
  output: {
    path: __dirname + "/.tmp/dist",
    filename: "javascripts/[name].js",
  },
  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: ExtractTextPlugin.extract("css-loader!csso-loader?-comments!sass-loader?sourceMap&includePaths[]=" + __dirname + "/node_modules")
      } , {
        test: /\.(jpe?g|png|gif|svg|woff|ttf|otf|eot|ico)/,
        loader: "url-loader"
      } , {
        test: /\.svg/,
        loader: "svg-url-loader"
      } , {
        test: /\.js$/,
        loader: "babel-loader",
        query: {
          presets: ["es2015"]
        }
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("stylesheets/[name].css")
  ]
};
