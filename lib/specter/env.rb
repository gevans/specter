module Specter
  class Env < Hash
    extend Forwardable

    attr_reader :request

    def_delegators :request, :command, :params

    def initialize(request)
      @request = request
    end

    def to_str
      "#{to_json}\x0"
    end
  end # Env
end # Specter
