require 'socket'
require 'logger'

require 'specter/middleware'
require 'specter/request'
require 'specter/env'

module Specter
  class Server

    attr_reader :cli

    attr_reader :options

    attr_reader :logger

    attr_reader :socket

    attr_reader :stack

    def initialize(cli)
      @cli     = cli
      @options = cli.options

      @logger = Logger.new(STDOUT)
      @socket = TCPServer.new(options[:host], options[:port])
      @stack  = Middleware.new(self)
    end

    def run
      BasicSocket.do_not_reverse_lookup = true
      return @thread = Thread.new { handle_requests }
    end

    def handle_requests
      loop do
        client = socket.accept
        process_request(client)
      end
    end

    def process_request(client)
      Timeout.timeout(5) do
        req = Request.parse(client.gets)
        env = Env.new(client, req)
        log_request(env)
        @stack.call(env)
        client.write env.to_str
      end
    rescue Timeout::Error
      log_timeout(client)
    rescue Object => e
      log_error(client, e)
    ensure
      client.close rescue nil
    end

    def log_timeout(client)
      logger.warn "%s - timeout" % [
        client.remote_address.ip_address
      ]
    end

    def log_error(client, e)
      logger.error "%s - %s: %s\n%s" % [
        client.remote_address.ip_address, e.class, e.message,
        e.backtrace.join("\n")
      ]
    end

    def log_request(env)
      logger.info "%s - %s - %s" % [
        env.client.remote_address.ip_address, env.request.command, env.request.args.inspect
      ]
    end
  end # Server
end # Specter
