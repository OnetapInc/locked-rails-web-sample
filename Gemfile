source 'https://rubygems.org'

gem 'rails',          '5.2.2'
gem 'actionview',     '5.2.2'
gem 'railties',       '5.2.2'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'bcrypt',         '3.1.11'
gem 'faker',          '1.7.3'
gem 'will_paginate',           '3.1.5'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'carrierwave',             '1.1.0'
gem 'mini_magick',             '4.9.4'
gem 'fog',                     '1.40.0'


gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'
gem 'therubyracer'
gem 'mysql2'

gem 'nokogiri'
gem 'locked-rb', :git => "https://github.com/OnetapInc/locked-ruby.git", :branch => "fix/adopt-docker"

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen',                '3.0.8'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.18.4'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
