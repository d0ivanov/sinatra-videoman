require 'sinatra/activerecord'
require 'protected_attributes'
require 'videoman/uploader.rb'

class Video < ActiveRecord::Base
  mount_uploader :video, VideoUploader
end
