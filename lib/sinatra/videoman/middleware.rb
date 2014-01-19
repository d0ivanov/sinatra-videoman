module Sinatra
  module Videoman
    module Middleware
      include Manager

      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.load_path = Dir[File.join(File.dirname(__FILE__)+'/locales', '*.yml')]
      I18n.backend.load_translations
      I18n.enforce_available_locales = true
      I18n.default_locale = Manager.config[:default_locale]

      def self.registered(app)
        app.register Sinatra::Partial
        app.set :partial_template_engine, :erb

        app.get '/videos/upload/?' do
          erb 'videos/upload'.to_sym
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
            flash[:notice] = I18n.t 'video_uploaded'
            redirect Manager.config[:after_video_save_path]
          else
            Manager.call :after_video_save_failure, [request, response]
            flash[:error] = video.errors.messages
            redirect '/videos/upload'
          end
        end

        app.get '/videos/watch/:id/?' do
          @video = Video.find_by id: params[:id]
          if @video
            erb 'videos/watch'.to_sym
          else
            I18n.t 'video_not_found'
          end
        end

        app.get '/videos/edit/:id/?' do
          @video = Video.find_by id: params[:id]
          if @video
            erb 'videos/edit'.to_sym
          else
            I18n.t 'video_not_found'
          end
        end

        app.post '/videos/edit/:id' do
          video = Video.find(params[:id])
          if video.update_attributes(params)
            video.save
            Manager.call :after_video_update, [video, request, response]
            flash[:notice] = I18n.t 'video_edited'
            redirect Manager.config[:after_video_update_path]
          else
            Manager.call :after_video_update_failure, [video, request, response]
            flash[:error] = video.errors.messages
            redirect "/videos/edit/#{video.id}"
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
            flash[:notice] = I18n.t 'video_deleted'
          end
          redirect Manager.config[:after_video_delete_path]
        end

        app.get '/videos/?' do
          @video_links = Video.all
          erb 'videos/list'.to_sym
        end
      end
    end
  end
end
