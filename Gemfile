
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

gem 'autoprefixer-rails'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bulma-rails', '~> 0.7.1'
gem 'carrierwave'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.5'
gem 'impressionist'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.11'
gem 'rails-i18n', '~> 5.1'
gem 'rmagick'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails', '~> 3.1', '>= 3.1.3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'activerecord-import'
gem 'rack-cors'
gem 'httpclient'
gem 'config'
gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug', '~> 3.6'
  gem 'pry-rails', '~> 0.3.6'
  gem 'rubocop', '~> 0.58.2', require: false
  gem 'rubocop-rspec'
  gem 'scss_lint', require: false
  gem 'slim_lint', require: false
  gem 'sqlite3', '~> 1.3.6'
end

group :development do
  gem 'devise-i18n'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 2.8'
  gem 'factory_bot_rails', '~> 4.10'
  gem 'rspec-rails', '~> 3.7'
end

group :production do
  gem 'mysql2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]