source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '2.3.2.0'
#used to create hash passwords
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'strong_parameters'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

group :test do		
	gem 'shoulda'
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
end

group :development, :test do
	gem 'rspec-rails', '2.13.1'
  gem 'factory_girl_rails', '4.2.1'
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
