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
          save_fixture(env)
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
        FileUtils.rm(fixture) rescue nil
        nil
      end

      def save_fixture(env)
        File.open(ROOT.join("#{env.command}.json"), 'w') do |f|
          f.write JSON.pretty_generate(env.to_hash)
        end
        logger.debug "saved fixture for #{env.command.inspect}"
      end
    end # Fixture
  end # Middleware
end # Specter
