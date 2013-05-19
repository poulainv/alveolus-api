EnjoyTheWeb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.2

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  ## Config Devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  ## Config paperclip on local
  PAPERCLIP_STORAGE_WEBAPP = {
    :styles => { :caroussel => "550x350!",:medium => "500x300>", :small => "240x160!"},
    :default_url => "img/missing.png",
     :convert_options => {
      :caroussel => "-quality 75 -strip", :small => "-quality 75 -strip",:medium => "-quality 75 -strip" }
  }

   PAPERCLIP_STORAGE_AVATAR = {
     :styles => { :small => "75x75#", :mini=>"50x50#"},
      :default_url => "/img/avatar.jpg",
      :convert_options => {
      :small => "-quality 75 -strip", :mini= => "-quality 75 -strip" }
  }
    
  ## Mailer
  config.action_mailer.default_url_options = { :host => 'localhost' }
  config.action_mailer.raise_delivery_errors = true

end
