var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: {
    blog: "./source/javascripts/blog.js"
  },
  entry: {
    styles: "./source/stylesheets/blog.scss"
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
        test: /\.svg/,
        loader: "svg-url-loader"
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("stylesheets/blog.css"),
  ]
};
