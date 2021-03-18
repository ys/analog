module Analog
  module Commands
    extend Dry::CLI::Registry

    register "overview", Overview
    register "html", Html
    register "rename", Rename
  end
end
