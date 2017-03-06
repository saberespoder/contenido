ruby "2.3.3"
#ruby-gemset=contentplatform_gems

# If you do not have OpenSSL installed, change
# the following line to use "http://"
source "https://rubygems.org"

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", platforms: [:mswin, :mingw]

# Windows does not come with time zone data
gem "tzinfo-data", platforms: [:mswin, :mingw, :jruby]

# Middleman Gems
gem "middleman", "~> 4.1"
gem "middleman-livereload"
gem "middleman-dotenv"
gem "middleman-s3_sync"
# Use github versions until `contentful_middleman` is fully v4 compatible
gem "contentful_middleman", github: "contentful/contentful_middleman", branch: "dl/upgrade-to-v4"
gem "redcarpet", "~> 3.3", ">= 3.3.3"
gem "slim"

gem "builder", "~> 3.0" # For feed.xml.builder
gem "mime-types"
gem "foreman"
