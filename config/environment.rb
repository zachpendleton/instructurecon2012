$: << File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'bundler'
require 'find'
require 'json'
require 'yaml'

Bundler.require

Find.find('lib').each do |path|
  require path if path.match(/\.rb$/)
end

config = YAML::load_file('config/canvas.yml')
CANVAS = Canvas::Client.new(config)
ACCOUNT_ID = config['account_id']
