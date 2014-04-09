require 'middleware'

require 'specter/middleware/base'
require 'specter/middleware/proxy'
require 'specter/middleware/fixture'

module Specter
  module Middleware

    def self.new(server)
      ::Middleware::Builder.new do
        use Fixture, server
        use Proxy, server if server.options[:proxy]
        yield if block_given?
      end
    end
  end # Middleware
end # Specter
