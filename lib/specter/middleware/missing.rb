module Specter
  module Middleware
    class Missing < Base

      def call(env)
        @app.call(env)

        if env.empty?
          env.merge!(
            'STATUS' => [
              {
                'STATUS' => 'E',
                'When' => Time.now.to_i,
                'Code' => 14,
                'Msg' => 'Invalid command',
                'Description' => "specter #{VERSION}"
              }
            ],
            'id' => 1
          )
        end
      end
    end # Missing
  end # Middleware
end # Specter
