module Specter
  module Middleware
    class Base
      extend Forwardable

      def initialize(app, server)
        @app = app
        @server = server
      end

      def_delegator :@server, :logger
    end # Base
  end # Middleware
end # Specter
