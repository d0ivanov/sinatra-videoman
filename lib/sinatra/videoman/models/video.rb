require 'active_record'
require 'protected_attributes'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'sinatra/videoman/uploader.rb'

class Video < ActiveRecord::Base
  include Sinatra::Videoman

  mount_uploader :video, VideoUploader
  validate :file_size

  def file_size
    if (video.file.size.to_f / 2**20).round(2) > Manager.config[:max_file_size]
      errors.add(:file, "You cannot upload a file greater than #{Manager.config[:max_file_size]}MB")
    end
  end
end
