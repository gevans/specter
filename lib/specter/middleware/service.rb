require 'specter/device'

module Specter
  module Middleware
    class Service < Base

      METHODS = %w(
        devs summary
      ).freeze

      def call(env)
        #raise NoMethodError unless METHODS.include?(request.command)
        if METHODS.include?(env.command)
          method_name = env.command.to_sym

          result = send(method_name, *env.params)
          result['STATUS'] ||= [
            {
              'STATUS' => 'S',
              'When' => Time.now.to_i,
              'Code' => 1, # simulate real codes? nah...
              'Msg' => 'Simulated response',
              'Description' => "specter #{Specter::VERSION}"
            }
          ]

          env.merge!(result)
        else
          @app.call(env)
        end
      end

      protected

      def devs
        {
          'DEVS' => Celluloid::Actor[:devices].collect(&:to_hash)
        }
      end

      def summary
        {
          'SUMMARY' => [Celluloid::Actor[:devices].collect(&:to_hash).inject(&:merge)]
        }
      end
    end # Service
  end # Middleware
end # Specter
