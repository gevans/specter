require 'middleware'

require 'specter/middleware/base'
require 'specter/middleware/fixture'
require 'specter/middleware/missing'
require 'specter/middleware/proxy'
require 'specter/middleware/service'

module Specter
  module Middleware

    def self.new(server)
      ::Middleware::Builder.new do
        use Service, server
        use Fixture, server
        use Proxy,   server if server.options[:proxy]

        yield if block_given?

        use Missing, server
      end
    end
  end # Middleware
end # Specter
