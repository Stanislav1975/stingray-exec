require "bundler/gem_tasks"

desc 'generate actions JSON from wsdl files'
task :generate_actions, :wsdl_dir do |t, args|
  wsdl_dir = args[:wsdl_dir]
  raise 'BORK' if wsdl_dir.nil? || wsdl_dir.empty?

  require File.expand_path('../generate-actions', __FILE__)

  outfile = File.expand_path(
    '../lib/stingray/control_api/generated-actions.json', __FILE__
  )

  File.open(outfile, 'w') do |f|
    ActionsGenerator.new(wsdl_dir, f).generate!
  end
end
