require "sinatra/videoman/version"
require "rack-flash"
require "bcrypt"
require "sinatra/base"
require "sinatra/activerecord"
require "carrierwave"

module Sinatra
  module Videoman
    module Manager
      @@config = {
        :upload_dir => "",
        :content_types => ""
      }

      @@callbacks = {}

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
    end
  end
end

require "sinatra/videoman/middleware"
require "sinatra/videoman/models/video"
