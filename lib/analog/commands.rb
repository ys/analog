module Analog
  module Commands
    extend Dry::CLI::Registry

    register "rolls:overview", Overview
    register "rolls:rename", Rename
    register "offline:build", Offline
  end
end
