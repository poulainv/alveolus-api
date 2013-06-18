source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'json'
gem 'active_model_serializers'
gem 'inherited_resources'


group :production do
   gem "newrelic_rpm", "~> 3.5.5.38"
  gem 'thin'
  gem 'pg'
  gem 'paperclip'
  gem 'rmagick'
  gem 'aws-sdk'
  gem 'devise'
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'certified'
  gem 'fb_graph'
  gem 'devise-i18n'
  gem 'activerecord-reputation-system', require: 'reputation_system'
  gem "squeel"
end

gem 'xpath'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem "newrelic_rpm", "~> 3.5.5.38"
  gem 'rspec-rails', '2.8.0'
  gem 'annotate'
  gem 'paperclip'
  gem 'rmagick'
  gem 'aws-sdk'
  gem 'devise'
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'certified'
  gem 'fb_graph'
  gem 'devise-i18n'
  gem 'activerecord-reputation-system', require: 'reputation_system'
  gem "squeel"
end

group :test do
  gem 'json_spec'
  gem 'rspec', '2.8.0'
  gem 'capybara', ">= 1.1.2"
  gem 'factory_girl_rails', '4.0'
  gem 'devise'
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'activerecord-reputation-system', require: 'reputation_system'

end

gem 'therubyracer'
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