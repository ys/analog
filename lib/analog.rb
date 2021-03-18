require "rubygems"
require "bundler/setup"
require "dry/cli"
require "active_model"
require "active_support/all"
require "yaml"
require "terminal-table"
require "zeitwerk"
require "liquid"

loader = Zeitwerk::Loader.for_gem
loader.setup

module Analog
  def self.start
    Analog::Config.load
    Dry::CLI.new(Analog::Commands).call
  end
end
