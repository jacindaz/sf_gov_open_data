source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 6.0'
# gem 'rails'
gem 'rails', '~> 6.0.3.7'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3'
# gem 'pg'

# Use Puma as the app server
# gem 'puma', '~> 3.7'
gem 'puma', '~> 4.3.8'
# gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'materialize-sass', '~> 0.100.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'sidekiq'
gem 'kaminari'
gem "elasticsearch-persistence"

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'awesome_print'
  gem 'rspec-rails', '~> 3.6'
  gem "factory_bot_rails", "~> 4.0"
  gem 'rubocop-rspec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'listen', '~> 3.7.0'

  # Hrmm: do I need this?
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
