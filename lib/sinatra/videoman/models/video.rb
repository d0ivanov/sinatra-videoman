require 'active_record'
require 'protected_attributes'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'sinatra/videoman/thumb_uploader.rb'

class Video < ActiveRecord::Base
  include Sinatra::Videoman
  has_many :video_files

  attr_accessible :title, :description, :thumbnail

  mount_uploader :thumbnail, ThumbUploader
  validate :file_size

  def file_size
    if (thumbnail.file.size.to_f / 2**20).round(2) > Manager.config[:max_thumb_file_size]
      errors.add(:file, "You cannot upload an image greater than #{Manager.config[:max_thumb_file_size]}MB")
    end
  end
end
