require 'optparse'
require 'uri'

module Specter
  class Cli

    DEFAULT_HOST = '0.0.0.0'

    DEFAULT_PORT = 5028

    attr_reader :options

    def initialize(argv)
      @argv = argv
      @options = {}
    end

    def self.start(argv)
      new(argv).run
    end

    def output_header
      puts "Booting Specter v#{VERSION}..."
      puts "* Running in #{RUBY_DESCRIPTION}"
      puts "* Listening on tcp://#{options[:host]}:#{options[:port]}"
      puts 'Use Ctrl-C to stop'
    end

    def run
      parse_options
      output_header

      @thread = @server.run
      @thread.run

      Signal.trap('INT') do
        puts 'Stopping...'
        @thread.exit
        exit
      end

      @thread.join
    end

    private

    def parse_options
      @options = {
        host: DEFAULT_HOST,
        port: DEFAULT_PORT,
        debug: true
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

        opts.on '-P', '--proxy [HOST[:PORT]]', 'Send unrecognized commands to an actual running miner',
          "Host defaults to `localhost', port defaults to `4028'" do |arg|
          options[:proxy] = arg.to_s.split(':', 2)

          case options[:proxy].size
          when 0
            options[:proxy] = ['localhost', 4028]
          when 1
            options[:proxy] << 4028
          end
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

      @server = Server.new(self)
    end
  end # Cli
end # Specter
