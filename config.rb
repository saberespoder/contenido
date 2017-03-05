require "lib/blog_helpers"
helpers BlogHelpers
include BlogHelpers

set :platform_url,      ENV["URL"]
set :platform_title,    ENV["TITLE"]
set :platform_subtitle, ENV["SUBTITLE"]

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

# Build exceptions

configure :build do
  ignore '/articles/index.html'
  ignore '/articles/show.html'
  ignore '/categories/show.html'
  #activate :relative_assets
end

# Contentful setup

activate :contentful do |f|
  f.space         = { sepcontent: ENV["CONTENTFUL_SPACE_ID"] }
  f.access_token  = ENV["CONTENTFUL_ACCESS_TOKEN"]
  f.content_types = {
    articles:   ENV["CONTENTFUL_ARTICLES_KEY"],
    categories: ENV["CONTENTFUL_CATEGORIES_KEY"]
  }
end

# Articles routes

sliced_articles = collection_slice(articles)

proxy "/index.html", "/articles/index.html",
  locals: slicer_attributes(sliced_articles, sliced_articles.first)

sliced_articles.each_with_index do |page_articles, page|
  proxy "/articles/pages/#{page+1}.html", "/articles/index.html",
    locals: slicer_attributes(sliced_articles, page_articles)
end

articles.each do |article|
  proxy "/articles/#{article.slug}.html", "/articles/show.html",
    locals: { article: article, related: related_articles(article) }
end

# Categories routes

categories.each do |category|
  category_articles = articles.select { |a| a.categories.map(&:id).include?(category.id) }
  collection_slice  = collection_slice(category_articles)

  proxy "/categories/#{category.slug}.html", "/categories/show.html",
    locals: { category: category }
      .merge(slicer_attributes(collection_slice, collection_slice.first, "/categories/#{category.slug}/pages"))

  collection_slice(category_articles).each_with_index do |page_articles, page|
    proxy "/categories/#{category.slug}/pages/#{page+1}.html", "/categories/show.html",
    locals: { category: category }
      .merge(slicer_attributes(collection_slice(category_articles), page_articles, "/categories/#{category.slug}/pages"))
  end
end
