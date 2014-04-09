require 'json'

module Specter
  class Request

    def self.parse(raw)
      begin
        message = JSON.parse(raw)
      rescue JSON::ParserError
        raise RequestError, $!
      end

      command = message['command']
      args = message['parameter'].to_s.split(',')

      new(command, args)
    end

    attr_reader :command

    attr_reader :args

    def initialize(command, args)
      if command.nil? || command.empty?
        raise RequestError, 'command not supplied'
      end

      @command = command.to_sym
      @args = args
    end

    def execute(client)
      client.send(command, *args)
    end

    def inspect
      "#<#{self.class} command:#{command}, args:#{args.inspect}>"
    end
  end # Request
end # Specer
