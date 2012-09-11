require 'git'
require 'heroku'

require 'heploy/version'
require 'heploy/configuration'
require 'heploy/command'
require 'heploy/command/deploy'

module Heploy
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end
  end
end
