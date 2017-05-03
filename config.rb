require "lib/blog_helpers"
helpers BlogHelpers
include BlogHelpers

activate :dotenv

set :content_url,      ENV["URL"]
set :content_title,    ENV["TITLE"]
set :content_subtitle, ENV["SUBTITLE"]
set :platform_url,     ENV["PLATFORM_URL"]
set :phone_number,     ENV["PHONE_NUMBER"]
set :feed_articles,    ENV["ARTICLES_PER_FEED"].to_i

page "/feed.xml", layout: false
page "404.html",  layout: :errors, directory_index: false

set :slim, { ugly: true, format: :html }
#set :relative_links, true

activate :directory_indexes

activate :external_pipeline,
  name:    :webpack,
  command: build? ? "./node_modules/webpack/bin/webpack.js --bail -p" : "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
  source:  ".tmp/dist",
  latency: 1

configure :development do
  activate :livereload
end

# Build exceptions

configure :build do
  ignore '/articles/index.html'
  ignore '/articles/show.html'
  ignore '/pages/show.html'
  ignore '/categories/show.html'
  #activate :relative_assets

  # S3 integration setup

  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = ENV["AWS_BUCKET"]
    s3_sync.region                     = ENV["AWS_REGION"]
    s3_sync.aws_access_key_id          = ENV["AWS_KEY"]
    s3_sync.aws_secret_access_key      = ENV["AWS_SECRET"]
    s3_sync.delete                     = false # We delete stray files by default.
    s3_sync.after_build                = false # We do not chain after the build step by default.
    s3_sync.prefer_gzip                = true
    s3_sync.path_style                 = true
    s3_sync.reduced_redundancy_storage = false
    s3_sync.acl                        = "public-read"
    s3_sync.encryption                 = false
    s3_sync.prefix                     = ""
    s3_sync.version_bucket             = false
    s3_sync.index_document             = "index.html"
    s3_sync.error_document             = "404.html"
  end
end

# Contentful setup

activate :contentful do |f|
  f.cda_query     = { limit: 1000 }
  f.space         = { sepcontent: ENV["CONTENTFUL_SPACE_ID"] }
  f.access_token  = ENV["CONTENTFUL_ACCESS_TOKEN"]
  f.content_types = {
    articles:   ENV["CONTENTFUL_ARTICLES_KEY"],
    categories: ENV["CONTENTFUL_CATEGORIES_KEY"],
    pages:      ENV["CONTENTFUL_PAGES_KEY"]
  }
end


# Articles routes

sliced_articles = collection_slice(articles)

proxy "/index.html", "/articles/index.html",
  locals: slicer_attributes(sliced_articles, sliced_articles.first)

sliced_articles.each_with_index do |page_articles, page|
  proxy "/articulos/pages/#{page+1}.html", "/articles/index.html",
    locals: slicer_attributes(sliced_articles, page_articles)
end

articles.each do |article|
  article.categories.each do |category|
    proxy article_path(article, category), "/articles/show.html",
      locals: { article: article, related: related_articles(article) }
  end
end

# Offers routes

offers.each do |offer|
  offer.categories.each do |category|
    proxy article_path(offer, category, :offer), "/articles/show.html",
      locals: { article: offer, related: related_articles(offer) }
  end
end

# Categories routes

categories.each do |category|
  category_articles = articles.select { |a| a.categories.map(&:id).include?(category.id) }
  collection_slice  = collection_slice(category_articles)

  proxy "/#{category.legacy_slug}.html", "/categories/show.html",
    locals: { category: category }
      .merge(slicer_attributes(collection_slice, collection_slice.first, "/#{category.legacy_slug}/pages"))

  collection_slice(category_articles).each_with_index do |page_articles, page|
    proxy "/#{category.legacy_slug}/pages/#{page+1}.html", "/categories/show.html",
      locals: { category: category }
        .merge(slicer_attributes(collection_slice(category_articles), page_articles, "/#{category.legacy_slug}/pages"))
  end

  proxy "/#{category.legacy_slug}.xml", "/feed.xml",
    layout: false, locals: { category_articles: category_articles }

  # Pages routes

  pages.each do |page|
    proxy "/#{page.slug}.html", "/pages/show.html", locals: { article: page }
  end
end
