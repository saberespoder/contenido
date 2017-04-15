var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: {
    default: "./source/javascripts/default.js",
    default: "./source/stylesheets/default.scss",
    errors: "./source/stylesheets/errors.scss"
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
        loader: "url-loader?limit=8192"
      } , {
        test: /\.svg/,
        loader: "svg-url-loader"
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("stylesheets/[name].css")
  ]
};
