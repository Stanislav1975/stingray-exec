require "bundler/gem_tasks"

stingray_tarball_name = 'ZeusTM_91_Linux-x86_64.tgz'
stingray_tarball_url = 'https://support.riverbed.com/download.htm' <<
  "?filename=public/software/stingray/trafficmanager/9.1/#{stingray_tarball_name}"
stingray_tarball_sha1sum = 'bef75c80dbf7f13572ccfefec7791083180e78e0'

desc 'downloads zeus/stingray traffic manager tarball'
task :download_stingray do
  unless have_stingray_tarball?(stingray_tarball_name, stingray_tarball_sha1sum)
    sh "curl -o '#{stingray_tarball_name}' '#{stingray_tarball_url}'"
  end
end

def have_stingray_tarball?(tarball, sha1sum)
  File.exists?(tarball) &&
    get_stingray_tarball_sha1sum(tarball) == sha1sum
end

def get_stingray_tarball_sha1sum(tarball)
  `openssl dgst -sha1 #{tarball}`.chomp.split.last
end
