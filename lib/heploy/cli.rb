require 'thor'
require 'heploy'

module Heploy
  class CLI < Thor

    method_option :verbose, type: :boolean, aliases: "-v", default: false

    desc 'staging', 'Deploys your application to your staging server.'
    def staging
      config = Heploy::Configuration.find
      Heploy::Command::Deploy.staging config, options['verbose']
    end

    desc 'production', 'Deploys your application to your production server.'
    def production
      config = Heploy::Configuration.find
      Heploy::Command::Deploy.production config, options['verbose']
    end

  end
end