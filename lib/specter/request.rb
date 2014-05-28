require 'json'

module Specter
  class Request

    def self.parse(raw)
      begin
        message = JSON.parse(raw)
      rescue JSON::ParserError => ex
        raise RequestError, ex
      end

      command = message['command']
      params  = message['parameter'].to_s.split(',')

      new(command, params)
    end

    attr_reader :command

    attr_reader :params

    def initialize(command, params)
      if command.nil? || command.empty?
        raise RequestError, 'command not supplied'
      end

      @command = command
      @params  = params
    end

    def to_env
      Env.new(self)
    end

    def inspect
      "#<#{self.class} command:#{command}, params:#{params.inspect}>"
    end
  end # Request
end # Specer
