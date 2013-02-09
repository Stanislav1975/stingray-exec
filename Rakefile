require "bundler/gem_tasks"

stingray_tarball_name = 'ZeusTM_91_Linux-x86_64.tgz'
stingray_tarball_url = 'https://support.riverbed.com/download.htm' <<
  "?filename=public/software/stingray/trafficmanager/9.1/#{stingray_tarball_name}"

desc 'generate actions YAML from wsdl files'
task :generate_actions, :wsdl_dir do |t, args|
  wsdl_dir = args[:wsdl_dir]
  raise 'BORK' if wsdl_dir.nil? || wsdl_dir.empty?

  require File.expand_path('../generate-actions', __FILE__)

  outfile = File.expand_path(
    '../lib/stingray/control_api/generated-actions.yml', __FILE__
  )

  File.open(outfile, 'w') do |f|
    ActionsGenerator.new(wsdl_dir, f).generate!
  end
end

desc 'downloads zeus/stingray traffic manager tarball'
task :download_stingray do
  unless File.exists?(stingray_tarball_name)
    sh "curl -o '#{stingray_tarball_name}' '#{stingray_tarball_url}'"
  end
end
