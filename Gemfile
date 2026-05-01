source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

gem 'rails', '~> 7.1.0'
gem 'puma', '>= 6.0'
gem 'tailwindcss-rails'
gem 'sprockets-rails'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :windows]
  gem 'sqlite3', '~> 2.0'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 4.0'
  gem 'pry-rails'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
end

group :production do
  gem 'pg'
end

gem 'tzinfo-data', platforms: [:windows, :jruby]

# PDF生成
gem 'prawn'
gem 'prawn-table'

gem 'rails-i18n', '~> 7.0'
gem 'minitest', '~> 5.0'

# OGP・SEO
gem 'meta-tags'
