require 'specter/attributes'

module Specter
  class Devices
    include Celluloid
    include Enumerable

    attr_reader :devices

    def initialize(devices = [])
      @devices = devices
    end

    def [](index)
      devices[index]
    end

    def <<(device)
      devices << device
    end

    def each(&block)
      devices.each(&block)
    end
  end # Devices

  class Device
    include Attributes
    include Celluloid

    attribute :temperature do
      initial  { rand(70..80) }
      minimum  70
      maximum  80
      step     1
      interval 5
    end

    attribute :fan_speed do
      initial  { rand(1..1_500) }
      minimum  1
      maximum  1_500
      step     { rand(1..50) }
      interval 5
    end

    attr_reader :variant

    attr_reader :started_at

    attr_reader :accepted

    attr_reader :rejected

    attr_reader :hardware_errors

    attr_reader :total_megahashes

    def initialize(variant, base_rate)
      @variant = variant

      @started_at       = Time.now
      @accepted         = 0
      @rejected         = 0
      @hardware_errors  = 0
      @total_megahashes = 0

      attributes[:hash_rate] = Field.new do
        initial  (base_rate * 1_000_000).to_i
        minimum  (initial * 0.8)
        maximum  (initial * 1.2)
        step     { rand(1_000..(initial * 0.015)) }
        interval 1
        format   { |v| (v / 1_000_000).round(4) }
      end

      every(1) { @total_megahashes = @total_megahashes + hash_rate.value }

      simulate_shares
    end

    def simulate_shares
      case rand(1..10_000)
      when 1..9_980
        @accepted += 1
      when 9_980..9_995
        @rejected += 1
      else
        @hardware_errors += 1
      end
    ensure
      after(rand(1..20), &method(:simulate_shares))
    end

    def hash_rate
      attributes[:hash_rate]
    end

    def to_hash
      {
        'Enabled' => 'Y',
        'Status' => 'Alive',
        'Temperature' => temperature.value.to_f,
        'Fan Speed' => fan_speed.value,
        'Fan Percent' => fan_speed.value * 100 / fan_speed.max,
        'GPU Clock' => 950,
        'Memory Clock' => 1500,
        'GPU Voltage' => 0.0,
        'GPU Activity' => 100,
        'Powertune' => 30,
        'MHS av' => hash_rate.mean,
        'MHS 1s' => hash_rate.value,
        'KHS av' => (hash_rate.mean * 1_000).round,
        'KHS 1s' => (hash_rate.value * 1_000).round,
        'Accepted' => accepted,
        'Rejected' => rejected,
        'Hardware Errors' => hardware_errors,
        'Utility' => 1.2345,
        'Intensity' => '0',
        'Last Share Pool' => 0,
        'Last Share Time' => Time.now.to_i,
        'Total MH' => total_megahashes.round(4),
        'Diff1 Work' => 123456,
        'Difficulty Accepted' => 123456.0,
        'Difficulty Rejected' => 512.0,
        'Last Share Difficulty' => 512.0,
        'Device Hardware%' => hardware_errors * 100 / (accepted + rejected),
        'Device Rejected%' => rejected * 100 / accepted,
        'Device Elapsed' => (Time.now - @started_at).to_i
      }
    end
  end # Device
end # Specter
