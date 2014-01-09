require 'rake'

namespace :video_views do
  desc 'Copy view files'
  task :install do
    Sinatra::Videoman::Tasks.install_views_task ENV["VIEWS_DIR"]
  end
end
