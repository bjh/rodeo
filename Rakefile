require 'bundler/gem_tasks'
require 'rodeo'
require 'pp'

task :manifest do
  Rodeo.configuration do |c|
    c.access_key_id = 'AKIAI5YD6AOWIGP64F5A'
    c.secret_access_key = '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'
    c.bucket = 'studeo'
  end

  manifest = Rodeo::Manifest.new
  manifest.load('BronzeC', 1)
  manifest.parse('BronzeC', 1)

  # pp manifest.manifest
  json = manifest.save('BronzeC', 1)
  puts json
  puts '-' * 40
  puts JSON.parse(json)
  # manifest.test_parse('BronzeC', 1)
  manifest.get('BronzeC', 1)
end
