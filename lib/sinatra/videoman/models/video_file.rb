require 'active_record'
require 'protected_attributes'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'sinatra/videoman/video_uploader.rb'

class VideoFile < ActiveRecord::Base
  include Sinatra::Videoman
  belongs_to :video

  attr_accessible :file, :content_type

  mount_uploader :file, VideoUploader
  validate :file_size

  def file_size
    if (file.file.size.to_f / 2**20).round(2) > Manager.config[:max_video_file_size]
      errors.add(:file, "You cannot upload a video greater than #{Manager.config[:max_video_file_size]}MB")
    end
  end
end
