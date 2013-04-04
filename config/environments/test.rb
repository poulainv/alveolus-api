

EnjoyTheWeb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  
   #Paperclip info storage
   PAPERCLIP_STORAGE = {
    :styles => { :caroussel => "550x350!"}
  }

  PAPERCLIP_STORAGE_AVATAR = {
     :styles => { :small => "75x75#", :mini=>"50x50#"},
      :default_url => "/img/avatar.jpg",
      :convert_options => {
      :small => "-quality 75 -strip", :mini= => "-quality 75 -strip" }
  }

  PAPERCLIP_STORAGE_WEBAPP = {
    :styles => { :caroussel => "550x350!",:medium => "500x300>", :small => "240x160!"},
     :convert_options => {
      :caroussel => "-quality 75 -strip", :small => "-quality 75 -strip",:medium => "-quality 75 -strip" }
  }
 
end
