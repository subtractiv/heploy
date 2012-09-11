require 'thor'
require 'heploy'

module Heploy
  class CLI < Thor

    desc 'staging', 'Deploys your application to your staging server.'
    def staging
      config = Heploy::Configuration.find
      Heploy::Command::Deploy.staging config
    end

    desc 'production', 'Deploys your applicationn to your staging server.'
    def production
      config = Heploy::Configuration.find
      Heploy::Command::Deploy.production config
    end

  end
end