module Heploy
  class Configuration

    attr_accessor :development_branch,
                  :staging_branch,
                  :production_branch,
                  :staging_app_name,
                  :production_app_name,
                  :heroku_email,
                  :heroku_api_key

    def self.find
      load Dir["config/heploy.rb"].first
    end

    def initialize
      @development_branch = "dev"
      @staging_branch = "staging"
      @production_branch = "production"   
    end

  end
end