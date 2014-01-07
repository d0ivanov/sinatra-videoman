require 'rake'

namespace :views do
  desc 'Copy view files'
  task :instal do
    Sinatra::Videoman::Tasks.install_views_task ENV["VIEWS_DIR"]
  end
end
