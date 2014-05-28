require 'optparse'
require 'uri'

module Specter
  class CLI

    DEFAULT_HOST = '0.0.0.0'.freeze

    DEFAULT_PORT = 5028

    attr_reader :options

    attr_reader :logger

    def initialize(argv)
      @argv    = argv
      @options = {}
      @logger  = Logger.new(STDOUT).tap do |log|
        log.level = Logger::INFO
      end
    end

    def self.start(argv)
      new(argv).run
    end

    def run
      parse_options

      begin
        @server = Server.new(self)
        output_header

        sleep 5 while @server.alive?
      rescue Interrupt
        puts 'Shutting down...'
        @server.shutdown
        exit
      end
    end

    private

    def parse_options
      @options = {
        host: DEFAULT_HOST,
        port: DEFAULT_PORT,
      }

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: specter [options]'

        opts.on '-H', '--host HOST',
          'Bind to a specific address' do |arg|
          options[:host] = arg
        end

        opts.on '-p', '--port PORT', 'Listen on a specific TCP port' do |arg|
          options[:port] = Integer(arg)
        end

        opts.on '-d', '--devices [VARIANT]:[HASHRATE],...', 'List of simulated devices' do |arg|
          options[:devices] = parse_devices(arg)
        end

        opts.on_tail '-v', '--version', 'Show version information and exit' do |arg|
          puts "specter v#{Specter::VERSION}"
          exit
        end

        opts.on_tail '-h', '--help', 'Show this help message and exit' do
          puts opts
          exit
        end
      end

      parser.parse!(@argv)

      if options[:devices].nil? || options[:devices].empty?
        options[:devices] = parse_devices('gpu:1,gpu:1,gpu:1')
      end

      Celluloid::Actor[:devices] = Devices.new(options[:devices])
    end

    def parse_devices(arg)
      arg.split(',').collect { |d|
        v, h = d.split(':', 2)
        Device.new(v.downcase.to_sym, Float(h))
      }
    end

    def output_header
      puts "Booting Specter v#{VERSION}..."
      puts "* Running in #{RUBY_DESCRIPTION}"
      puts "* Listening on tcp://#{options[:host]}:#{options[:port]}"
      puts 'Use Ctrl-C to stop'
    end
  end # Cli
end # Specter
