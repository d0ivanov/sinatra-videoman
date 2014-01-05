require 'digest/sha1'

class VideoUploader < CarrierWave::Uploader::Base
  include Sinatra::Videoman

  storage :file

  def store_dir
    Manager.config[:video_upload_dir]
  end

  def extension_white_list
    Manager.config[:video_file_extensions]
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end
end
