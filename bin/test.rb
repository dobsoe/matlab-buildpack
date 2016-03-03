$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'java_buildpack/buildpack'
require 'java_buildpack/util/cache'
require 'java_buildpack/util/cache/download_cache'
require 'open-uri'


build_dir = ARGV[0]

JavaBuildpack::Buildpack.with_buildpack(build_dir, 'Compile failed with exception %s') do |buildpack|
  buildpack.compile
end

JavaBuildpack::Util::Cache::DownloadCache.new(Pathname.new("/tmp/ellie/")).get('http://uk.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/glnxa64/MCR_R2015b_glnxa64_installer.zip')
# do |file|
Dir.chdir("/tmp/ellie") 
#   file.close
#  end
#end
value = `unzip MCR_R2015b_glnxa64_installer.zip`
value = `./install -mode silent -agreeToLicense yes`

