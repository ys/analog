module Analog
  module Commands
    extend Dry::CLI::Registry

    register "rolls:exif:read", ExifRead
    register "rolls:exif", ExifWrite
    register "rolls:overview", Overview
    register "rolls:details", Details
    register "rolls:stats", Stats
    register "rolls:rename", RollsRename
    register "photos:rename", PhotosRename
    register "catalog", Catalog
    register "rolls:offline", Offline
    register "rolls:debug", Debug
    register "rolls:archive", Archive
    register "rolls:csv", Csv
  end
end
