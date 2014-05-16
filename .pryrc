require 'bundler/setup'
require 'specter'
require 'expedition'

def reload!
  old_verbose, $VERBOSE = $VERBOSE, nil
  Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort.each { |f| load f }
ensure
  $VERBOSE = old_verbose
end

def specter(host = 'localhost', port = 5028)
  @specter ||= Expedition.new(host, port)
end

def miner(host = 'localhost', port = 4028)
  @miner ||= Expedition.new(host, port)
end
