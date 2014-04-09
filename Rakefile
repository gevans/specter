require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Generate a fixture for supplied command'
task :generate_fixture, [:command] do |t, args|
  if args[:command].nil? || args[:command].empty?
    abort 'no command specified'
  end

  command = args[:command].to_sym

  require 'expedition'
  client = Expedition::Client.new(
    ENV['EXPEDITION_HOST'] || 'localhost',
    ENV['EXPEDITION_PORT'] || 4028
  )

  fixture_path = File.expand_path("../lib/specter/fixtures/#{command}.json", __FILE__)
  File.open(fixture_path, 'w') do |f|
    f.write JSON.pretty_generate(client.send(command).raw)
  end
  puts "Wrote fixture to #{fixture_path}"
end

task default: :spec
