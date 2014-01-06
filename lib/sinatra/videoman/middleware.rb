require 'sinatra/partial'

module Sinatra
  module Videoman
    class Middleware < Sinatra::Base
      include Manager
      register Sinatra::Partial
      set :partial_template_engine, :erb

      get '/videos/upload/?' do
        erb :upload
      end

      post '/videos/upload' do
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

      get '/videos/show/:id/?' do
        @video = Video.find(params[:id])
        erb :show
      end

      get '/videos/edit/:id/?' do
        @video = Video.find(params[:id])
        erb :edit
      end

      post '/videos/edit/:id' do
        video = Video.find(params[:id])
        video.update_atributes(params)
        if video.valid?
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

      post '/videos/delete/:id' do
        video = Video.find(params[:id])
        Manager.call :before_video_delete, [video, request, response]
        if video
          video.thumbnail.remove!
          video.video_files.each {|file| file.file.remove!}
          video.delete
          Manager.call :after_video_delete, [request, response]
          flash[:notice] = Manager.config[:after_video_delete_msg]
        end
        redirect Manager.config[:after_video_delete_path]
      end

      get '/videos/' do
        @videos = Video.all
        erb :index
      end
    end
  end
end
