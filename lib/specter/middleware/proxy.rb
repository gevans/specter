require 'expedition'

module Specter
  module Middleware
    class Proxy < Base

      def initialize(app, server)
        super
        @miner = Expedition::Client.new(*options[:proxy])
      end

      def call(env)
        env.merge!(proxy_command(env))
        @app.call(env)
      end

      private

      def proxy_command(env)
        logger.debug "proxying #{env.command}, #{env.args.inspect}"
        @miner.send(env.command, *env.args).raw
      end
    end # Proxy
  end # Middleware
end # Specter
