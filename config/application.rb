require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TwitterApiRails
  class Application < Rails::Application
    config.load_defaults 7.0
    initializer(:remove_action_mailbox_and_activestorage_routes, after: :add_routing_paths) { |app|
         app.routes_reloader.paths.delete_if {|path| path =~ /activestorage/}
         app.routes_reloader.paths.delete_if {|path| path =~ /actionmailbox/ }
       }

    # Changed to 'false' for session management
    config.api_only = false
  end
end
