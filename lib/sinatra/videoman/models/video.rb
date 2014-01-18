require 'active_record'
require 'protected_attributes'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'sinatra/videoman/thumb_uploader.rb'

class Video < ActiveRecord::Base
  include Sinatra::Videoman

  attr_accessible :title, :description, :thumbnail

  mount_uploader :thumbnail, ThumbUploader
  has_many :video_files

  validates :title, :description, :thumbnail, presence: true
  validate :file_size

  def file_size
    if thumbnail.file && (thumbnail.file.size.to_f / 2**20).round(2) > Manager.config[:max_video_file_size]
      errors.add(:thumbnail, "You cannot upload a file greater than #{Manager.config[:max_video_file_size]}MB")
    end
  end

end
