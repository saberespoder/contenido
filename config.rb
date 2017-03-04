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
  ignore '/categories/show.html'
  ignore '/articles/show.html'
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

# Dynamic routes mappings

articles.each do |article|
  proxy "/articles/#{article.slug}.html", "/articles/show.html", locals: {
    article: article,
    related: related_articles(article)
  }
end

collection_slice(articles).each_with_index do |page_articles, page|
  proxy "/articles/pages/#{page+1}.html", "/index.html", locals: {
    page_articles: page_articles
  }
end

# @TODO: Dry it

categories.each do |category|
  category_articles = articles.select { |a| a.categories.map(&:id).include?(category.id) }

  proxy "/categories/#{category.slug}.html", "/categories/show.html", locals: {
    category:          category,
    category_articles: collection_slice(category_articles).first
  }
  collection_slice(category_articles).each_with_index do |page_articles, page|
    proxy "/categories/#{category.slug}/pages/#{page+1}.html", "/categories/show.html", locals: {
      category:      category,
      page_articles: page_articles
    }
  end
end
