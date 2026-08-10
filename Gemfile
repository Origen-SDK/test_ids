# frozen_string_literal: true

source 'https://rubygems.org'

# Only development dependencies (things your only plugin needs when running in its own workspace) should
# be listed here in the Gemfile
# This gem provides integration with https://coveralls.io/ to monitor
# your application's test coverage
gem 'byebug', '~> 11.1' # 8.x fails to compile with Ruby 2.7 on current Windows toolchains
gem 'coveralls', require: false
gem 'origen_doc_helpers'
gem 'ripper-tags'
# Uncomment these if you want to use a visual debugger (e.g. Visual Studio Code) to debug your app
# gem 'ruby-debug-ide'
# gem 'debase'
gem 'nokogiri' # , '1.10.10'

# Specify your gem's runtime dependencies in test_ids.gemspec
# THIS LINE SHOULD BE LEFT AT THE END
gemspec
