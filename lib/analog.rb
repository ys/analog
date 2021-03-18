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
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class HTML < Dry::CLI::Command
        desc "Add a contact sheet per roll"
        option :path

        def call(**options)
          Analog::Config.path = options[:path]
          Analog::Roll.all.each do |r|
            r.add_contact_sheet
          end
        end
      end

      class Overview < Dry::CLI::Command
        desc "See all"
        option :path

        def call(**options)
          Analog::Config.path = options[:path]
          t = Terminal::Table.new
          t.style = { border: :unicode }
          Analog::Roll.all.each do |r|
            t << [ "##{r.roll_number}", r.scanned_at ]
            t << [ "camera", r.camera.to_s ]
            t << [ "film", r.film.to_s ]
            t << [ "dir", r.dir ]
            t << :separator
          end
          puts t
        end
      end

      class Rename < Dry::CLI::Command
        desc "Rename roll pictures based on information"
        option :dry_run, type: :boolean
        option :path

        def call(**options)
          Analog::Config.path = options[:path]
          Analog::Roll.all.each do |r|
            t = Terminal::Table.new
            t.style = { border: :unicode }
            t << [ r.roll_number + " " + r.dir]
            t << :separator
            r.files.each_with_index do |f, i|
              ext = File.extname(f)
              next if ext.match? /md|html/
              new_name = "#{r.scanned_at.strftime('%Y%m%d')}-#{r.roll_number}-#{i+1}#{ext.downcase}"
              unless options[:dry_run]
                Fileutils.mv(File.join(dir, f), File.join(dir, new_name))
              end
              t << ["#{f} → #{new_name}"]
            end
            puts t
          end
        end
      end

      register "rename", Rename
      register "overview", Overview
      register "html", HTML
    end
  end
end
