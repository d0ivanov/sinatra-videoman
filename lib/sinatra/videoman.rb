require "sinatra/videoman/version"
require "rack-flash"
require "bcrypt"
require "sinatra/base"
require "active_record"
require "carrierwave"

module Sinatra
  module Videoman
    module Manager
      @@config = {
        :upload_dir => nil,
        :file_extensions => %w(ogv webm mp4),
        :max_file_size => 400
      }
      @@callbacks = {}

      @@_after_upload_path = '/'
      @@_after_upload_msg = 'Successfully uploaded video!'
      @@_after_upload_failure_path = '/'
      @@_after_upload_failure_msg = 'Failed to upload video!'

      @@_after_update_path = '/'
      @@_after_update_msg = 'Successfully updated video!'
      @@_after_update_failure_path = '/'
      @@_after_update_failure_msg = 'Failed to update video!'

      @@_after_delete_path = '/'
      @@_after_delete_msg = 'Successfully deleted video!'

      def self.config &block
        yield(@@config) if block_given?
        @@config
      end

      def self.registered? hook
        @@callbacks.has_key? hook
      end

      def self.register hook, &block
        if self.registered? hook
          @@callbacks[hook].push block
        else
          @@callbacks[hook] = [block]
        end
      end

      def self.call hook, args = []
        if self.registered? hook
          @@callbacks[hook].each do |callback|
            callback.call(args)
          end
        end
      end

      def self.after_upload &block
        self.register :after_upload, &block
      end

      def self.after_upload_failure &block
        self.register :after_upload_failure, &block
      end

      def self.after_update &block
        self.register :after_update, &block
      end

      def self.after_update_failure &block
        self.register :after_update_failure, &block
      end

      def self.before_delete &block
        self.register :after_delete, &block
      end

      def self.after_delete &block
        self.register :after_delete, &block
      end

      def self.after_upload_path path, msg
        @@_after_upload_path, @@_after_upload_msg = path, msg
      end

      def self.after_upload_failure_path path, msg
        @@_after_upload_failure_path, @@_after_upload_failure_msg = path, msg
      end

      def self._after_upload_path
        @@_after_upload_path
      end

      def self._after_upload_failure_path
        @@_after_upload_failure_path
      end

      def self._after_upload_msg
        @@_after_upload_msg
      end

      def self._after_upload_failure_msg
        @@_after_upload_failure_msg
      end

      def self.after_update_path path, msg
        @@_after_update_path, @@_after_update_msg = path, msg
      end

      def self.after_update_failure_path path, msg
        @@_after_update_failure_path, @@_after_update_failure_msg = path, msg
      end

      def self._after_update_path
        @@_after_update_path
      end

      def self._after_update_failure_path
        @@_after_update_failure_path
      end

      def self.after_delete_path path, msg
        @@_after_delete_path, @@_after_delete_msg = path, msg
      end

      def self._after_delete_path
        @@_after_delete_path
      end

      def self._after_delete_msg
        @@_after_delete_msg
      end
    end
  end
end

require "sinatra/videoman/middleware.rb"
require "sinatra/videoman/uploader.rb"
require "sinatra/videoman/models/video.rb"
