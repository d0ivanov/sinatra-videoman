require 'active_record'
require 'protected_attributes'
require 'paperclip'

class Video < ActiveRecord::Base
  include Paperclip::Glue

  attr_accessible :video, :title, :tags
  has_attached_file :video

  validates_attachment :video, :presence => true,
    :content_type => { :content_type => %w(video/ogv video/webm video/mp4) },
    :size => { :in => 0..200.megabytes },
    :path => Manager.settings[:upload_dir]

  def tags
    self.tags.split(",")
  end
end
