Tyful::Application.configure do
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

    GRAPH_APP_ID = '295922833823667'
    GRAPH_SECRET = 'b79bd680c9c8c659a2c79a98d366852d'
    #ENV["REDISTOGO_URL"] = 'redis://localhost:6379' 
    ENV["FLASH_URL"] = 'http://localhost:5000/f/client/'
    ENV["RELAY_URL"] = 'http://localhost:5000/r/'
    ENV["TEMPLATE_URL"] = 'http://localhost:5000/t/'
    ENV["TEMPLATE_PREVIEW_URL"] = 'http://localhost:5000/tp/'
    ENV['FB_APP_ID'] = '295922833823667'
end
