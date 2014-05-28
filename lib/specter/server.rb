require 'celluloid'
require 'celluloid/io'

require 'specter/env'
require 'specter/middleware'
require 'specter/request'

module Specter
  class Server
    extend Forwardable
    include Celluloid::IO

    attr_reader :cli

    def_delegators :cli, :options, :logger

    def initialize(cli)
      @cli    = cli
      @socket = TCPServer.new(options[:host], options[:port])
      @stack  = Middleware.new(self)

      async.run
    end

    def run
      loop { async.handle_connection(@socket.accept) }
    end

    def shutdown
      @socket.close rescue nil
    end

    def handle_connection(socket)
      raw = socket.gets.chomp
      env = Request.parse(raw).to_env

      @stack.call(env)

      res = env.to_str

      socket.write res
      puts "#{raw} - #{res}"
    rescue Exception => ex
      log_error socket, ex
    ensure
      socket.close rescue nil
    end

    private

    def log_timeout(client)
    end

    def log_error(client, ex)
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace.join("\n")
    end

    def log_request(env)
    end
  end # Server
end # Specter
