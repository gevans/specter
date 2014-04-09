require 'pathname'

module Specter
  module Middleware
    class Fixture < Base

      ROOT = Pathname.new(File.expand_path('../../fixtures', __FILE__))

      def call(env)
        data = load_fixture(env)

        if data
          env.merge!(data)
        else
          @app.call(env)
        end
      end

      private

      def load_fixture(env)
        fixture = ROOT.join("#{env.command}.json")
        return unless fixture.exist?
        logger.debug "loading fixture for #{env.command.inspect}"
        JSON.load(File.read(fixture))
      rescue JSON::ParserError
        logger.debug "failed to parse fixture for #{env.command.inspect}"
        nil
      end
    end # Fixture
  end # Middleware
end # Specter
