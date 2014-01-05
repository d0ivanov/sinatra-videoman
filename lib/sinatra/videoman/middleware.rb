module Sinatra
  module Videoman
    class Middleware < Sinatra::Base
      include Manager

      get '/videos/upload/?' do
        erb :upload
      end

      post '/videos/upload' do
        video_file = VideoFile.new(params)
        video_file.video = params[:video]
        if video_file.valid?
          video_file.save!
          Manager.call :after_upload, [video_file, request, response]
          flash[:notice] = Manager._after_upload_msg
          redirect Manager._after_upload_path
        else
          Manager.call :after_upload_failure, [request, response]
          flash[:error] = Manager._after_upload_failure_msg
          redirect Manager._after_upload_failure_path
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
          Manager.call :after_update, [video, request, response]
          flash[:notice] = Manager._after_update_msg
          redirect Manager._after_update_path
        else
          Manager.call :after_update_failure, [video, request, response]
          flash[:error] = Manager._after_update_failure_msg
          redirect Manager._after_update_failure_path
        end
      end

      post '/videos/delete/:id' do
        video = Video.find(params[:id])
        Manager.call :before_delete, [video, request, response]
        if video
          video.video.remove!
          video.delete
          Manager.call :after_delete, [request, response]
          flash[:notice] = Manager._after_delete_msg
        end
        redirect Manager._after_delete_path
      end

      get '/videos/' do
        @videos = Video.all
        erb :index
      end
    end
  end
end
