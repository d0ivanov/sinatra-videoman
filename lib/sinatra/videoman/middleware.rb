module Sinatra
  module Videoman
    class Middleware < Sinatra::Base
      include Manager

      get '/videos/upload/?' do
        erb :upload
      end

      post '/videos/upload' do
        video = Video.new(params)
        if video.valid?
          video.save
          flash[:notice] = "Successfully uploaded video!"
        else
          flash[:error] = video.errors.messages
          redirect '/videos/upload'
        end
      end

      get '/videos/show/:id/?' do
        erb :show
      end

      get '/videos/edit/:id/?' do
        erb :edit
      end

      post '/videos/edit/:id' do
        video = Video.find(params["id"])
        video.update_atributes(params)
        video.save
        Manager.call :after_update, video
      end

      post 'videos/delete/:id' do
        video = Video.find(params["id"])
        Manager.call :before_delete, video
        video.delete
      end

      get '/videos' do
        erb :index
      end
    end
  end
end
