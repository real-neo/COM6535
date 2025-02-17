require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FitnessForStudents
  class Application < Rails::Application
    # Send queued jobs to delayed_job
    config.active_job.queue_adapter = :delayed_job

    # This points to our own routes middleware to handle exceptions
    config.exceptions_app = self.routes

    I18n.enforce_available_locales = false
    config.generators do |g|
      g.orm                 :active_record
      g.template_engine     :haml
      g.fixture_replacement :factory_bot,
                              dir: 'spec/factories'
      g.test_framework      :rspec,
                              fixture: true,
                              helper_specs: true,
                              routing_specs: false,
                              controller_specs: false,
                              view_specs: false,
                              integration_tool: false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
