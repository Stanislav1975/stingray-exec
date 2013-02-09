require "bundler/gem_tasks"

stingray_tarball_name = 'ZeusTM_91_Linux-x86_64.tgz'
stingray_tarball_url = 'https://support.riverbed.com/download.htm' <<
  "?filename=public/software/stingray/trafficmanager/9.1/#{stingray_tarball_name}"

desc 'downloads zeus/stingray traffic manager tarball'
task :download_stingray do
  unless File.exists?(stingray_tarball_name)
    sh "curl -o '#{stingray_tarball_name}' '#{stingray_tarball_url}'"
  end
end
