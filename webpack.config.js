var webpack = require('webpack');

module.exports = {
  entry: {
    blog: './source/javascripts/blog.js'
  },
  output: {
    path: __dirname + '/.tmp/dist',
    filename: 'javascripts/[name].js',
  },
};
