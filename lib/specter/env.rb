module Specter
  class Env < Hash
    extend Forwardable

    attr_reader :client

    attr_reader :request

    def_delegators :request, :command, :args

    def initialize(client, request)
      @client  = client
      @request = request
    end

    def to_str
      "#{to_json}\x0"
    end
  end # Env
end # Specter
