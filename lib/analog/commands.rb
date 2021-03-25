module Analog
  module Commands
    extend Dry::CLI::Registry

    register "rolls:overview", Overview
    register "rolls:details", Details
    register "rolls:stats", Stats
    register "rolls:rename", Rename
    register "offline:build", Offline
    register "catalog:build", Catalog
  end
end
