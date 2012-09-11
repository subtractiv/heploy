require 'heploy/version'
require 'heploy/configuration'

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
