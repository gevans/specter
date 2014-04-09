module Specter
  module Middleware
    class Base
      extend Forwardable

      def initialize(app, server)
        @app = app
        @server = server
      end

      def_delegators :@server, :logger, :options
    end # Base
  end # Middleware
end # Specter
