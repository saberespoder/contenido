require "lib/blog_helpers"
helpers BlogHelpers

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "/feed.xml", layout: false

configure :development do
  activate :livereload
end

activate :blog do |blog|
  blog.permalink = "categories/{category}/{title}.html"
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"

  blog.custom_collections = {
    :category => {
      :link     => '/categories/:category.html',
      :template => '/category.html'
    }
  }
end

set :slim, { ugly: true, format: :html }

activate :external_pipeline,
  name:    :webpack,
  command: build? ? "./node_modules/webpack/bin/webpack.js --bail -p" : "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
  source:  ".tmp/dist",
  latency: 1
