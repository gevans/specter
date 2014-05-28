module Specter
  class Field

    TRENDS = %i(positive negative neutral).freeze

    attr_reader :trend

    def initialize(&block)
      @trend      = :neutral
      @next_trend = 0
      @cycle      = 0
      @interval   = 1

      format { |value| value }

      instance_eval(&block)

      @value  = initial
      @values = [@value]

      Celluloid.every(interval, &method(:cycle))
    end

    %w[initial minimum maximum step].each do |attr|

      class_eval <<-RUBY, __FILE__, __LINE__ +1
        def #{attr}(value = nil, &block)
          value = block if block_given?
          if value
            @#{attr} = value
          else
            @#{attr}.respond_to?(:call) ? @#{attr}.call : @#{attr}
          end
        end
      RUBY
    end

    alias_method :min, :minimum
    alias_method :max, :maximum

    def interval(value = nil)
      @interval = value if value
      @interval
    end

    def format(&block)
      @format = block if block_given?
      @format
    end

    def value
      format.call(@value)
    end

    def mean
      format.call(@values.inject(&:+) / @values.length)
    end

    def cycle
      if next_trend?
        update_trend
        @next_trend = rand(1..5)
        @cycle = 0
      else
        @cycle += 1
      end

      @trend = :positive if @value <= minimum
      @trend = :negative if @value >= maximum

      @values << @value = @value + random_step
      @values.shift if @values.length > 60
    end

    private

    def next_trend?
      @cycle == @next_trend
    end

    def update_trend
      @trend = TRENDS.sample
    end

    def random_step
      return 0 if @trend == :neutral
      @trend == :positive ? step : step * -1
    end
  end # Field
end # Specter
