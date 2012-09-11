require 'heploy/version'
require 'heploy/configuration'

module Heploy
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
    configuration
  end
end
