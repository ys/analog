module Analog
  module Commands
    extend Dry::CLI::Registry

    register "exif:read", ExifRead
    register "exif:write", ExifWrite
    register "rolls:overview", Overview
    register "rolls:details", Details
    register "rolls:stats", Stats
    register "rolls:rename", RollsRename
    register "photos:rename", PhotosRename
    register "offline:build", Offline
    register "catalog:build", Catalog
    register "rolls:debug", Debug
  end
end
