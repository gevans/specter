require 'middleware'

require 'specter/middleware/base'
require 'specter/middleware/fixture'
require 'specter/middleware/missing'
require 'specter/middleware/proxy'

module Specter
  module Middleware

    def self.new(server)
      ::Middleware::Builder.new do
        use Fixture, server
        use Proxy, server if server.options[:proxy]

        yield if block_given?

        use Missing, server
      end
    end
  end # Middleware
end # Specter
