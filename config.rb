require "lib/blog_helpers"
helpers BlogHelpers
include BlogHelpers

page "/feed.xml", layout: false

set :slim, { ugly: true, format: :html }
#set :relative_links, true

activate :external_pipeline,
  name:    :webpack,
  command: build? ? "./node_modules/webpack/bin/webpack.js --bail -p" : "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
  source:  ".tmp/dist",
  latency: 1

configure :development do
  activate :livereload
  activate :dotenv
end

configure :build do
  ignore '/category.html'
  #activate :relative_assets
end

activate :contentful do |f|
  f.space         = { sepcontent: ENV["CONTENTFUL_SPACE_ID"] }
  f.access_token  = ENV["CONTENTFUL_ACCESS_TOKEN"]
  f.content_types = {
    articles:   ENV["CONTENTFUL_ARTICLES_KEY"],
    categories: ENV["CONTENTFUL_CATEGORIES_KEY"]
  }
end

articles.each do |article|
  proxy "/articles/#{article.slug}.html", "/articles/show.html", locals: {
    article: article,
    related: related_articles(article)
  }
end

categories.each do |category|
  proxy "/categories/#{category.slug}.html", "/categories/show.html", locals: {
    category:          category,
    category_articles: articles.select { |a|
      a.categories.map(&:id).include?(category.id)
    }
  }
end
