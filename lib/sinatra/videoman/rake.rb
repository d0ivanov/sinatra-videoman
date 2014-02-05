require 'fileutils'

module Sinatra
  module Videoman
    module Tasks
      def self.install_views_task views_dir
        current_path = File.expand_path(File.dirname(__FILE__))
        Dir.foreach(current_path + '/views') do |item|
          next if item == '.' or item == '..'
          File.open(File.join(current_path, 'views', item), 'r') do |file|
            if !File.exists?(File.join(views_dir, item))
              File.open(File.join(views_dir, item), 'w') do |view|
                while line = file.gets
                  view.write line
                end
              end
            end
          end
        end
      end
    end
  end
end

load 'sinatra/videoman/tasks.rake'
