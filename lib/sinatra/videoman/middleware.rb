module Sinatra
  module Videoman
    module Middleware
      include Manager
      def self.registered(app)
        app.register Sinatra::Partial
        app.set :partial_template_engine, :erb

        app.get '/videos/upload/?' do
          erb :upload
        end

        app.post '/videos/upload' do
          video = Video.new(params[:video])
          params[:video_files].each do |file|
            file = VideoFile.new(:file => file, :content_type => file[:type])
            if file.valid?
              video.video_files << file
              file.save!
              Manager.call :after_file_upload, [file]
            else
              Manager.call :after_file_upload_failure, [request, response]
              flash[:error] = file.errors.messages
              redirect '/videos/upload'
            end
          end
          if video.valid? && video.video_files.size >= 1
            video.save!
            Manager.call :after_video_save, [video, request, response]
            flash[:notice] = Manager.config[:after_video_save_msg]
            redirect Manager.config[:after_video_save_path]
          else
            Manager.call :after_video_save_failure, [request, response]
            flash[:error] = video.errors.messages
            redirect '/videos/upload'
          end
        end

        app.get '/videos/show/:id/?' do
          @video = Video.find_by id: params[:id]
          if @video
            erb :show
          else
            'No video found'
          end
        end

        app.get '/videos/edit/:id/?' do
          @video = Video.find_by id: params[:id]
          if @video
            erb :edit
          else
            'No video found'
          end
        end

        app.post '/videos/edit/:id' do
          video = Video.find(params[:id])
          if video.update_attributes(params)
            video.save
            Manager.call :after_video_update, [video, request, response]
            flash[:notice] = Manager.config[:after_video_update_msg]
            redirect Manager.config[:after_video_update_path]
          else
            Manager.call :after_video_update_failure, [video, request, response]
            flash[:error] = video.errors.messages
            redirect Manager.config[:after_video_update_failure_path]
          end
        end

        app.post '/videos/delete/:id' do
          video = Video.find_by id: params[:id]
          if video
            Manager.call :before_video_delete, [video, request, response]
            video.thumbnail.remove!
            video.video_files.each  do |file|
              file.file.remove!
              file.destroy!
            end
            video.destroy!
            Manager.call :after_video_delete, [request, response]
            flash[:notice] = Manager.config[:after_video_delete_msg]
          end
          redirect Manager.config[:after_video_delete_path]
        end

        app.get '/videos/?' do
          @videos = Video.all
          erb :index
        end
      end
    end
  end
end
