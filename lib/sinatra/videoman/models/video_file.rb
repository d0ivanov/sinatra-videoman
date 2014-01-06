require 'active_record'
require 'protected_attributes'
require 'carrierwave'
require 'sinatra/videoman/video_uploader.rb'

class VideoFile < ActiveRecord::Base
  include Sinatra::Videoman
  mount_uploader :file, VideoUploader
  belongs_to :video

  validates :file, presence: true

  validate :file_size

  def file_size
    if file.file && (file.file.size.to_f / 2**20).round(2) > Manager.config[:max_thumb_file_size]
      errors.add(:file, "You cannot upload a file greater than #{Manager.config[:max_thumb_file_size]}MB")
    end
  end
end
