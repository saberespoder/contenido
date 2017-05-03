require "rspec"
require "capybara/rspec"

require "middleman-core"
require "middleman-core/rack"

require "contentful_middleman"
require "middleman-livereload"
require "middleman-dotenv"

middleman_app = ::Middleman::Application.new

Capybara.app = ::Middleman::Rack.new(middleman_app).to_app do
  set :root, File.expand_path(File.join(File.dirname(__FILE__), ".."))
  set :environment, :test
end

RSpec.configure do |config|
  config.formatter = :documentation
end
