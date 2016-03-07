# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2016 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/component/base_component'
require 'java_buildpack/framework'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch MATLAB support.
    class Matlab < JavaBuildpack::Component::BaseComponent

      def initialize(context, &version_validator)
        super(context, &version_validator)
        @component_name = 'Matlab'
      end

      # (see JavaBuildpack::Component::BaseComponent#detect)
      def detect
        return 'matlab'
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download("", "http://uk.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/glnxa64/MCR_R2015b_glnxa64_installer.zip", @component_name) do |file|
          with_timing "Expanding matlab to some dir" do
            #Dir.mktmpdir do |root|
            FileUtils.mkdir_p("/tmp/matlab")
            shell "unzip -qq #{file.path} -d /tmp/matlab 2>&1"
            FileUtils.cd("/tmp/matlab", :verbose => true) do
              ret=shell "./install  -mode silent -agreeToLicense yes &>/tmp/matlab/log.out"
              puts "installation output"
              puts ret
              file=File.open("log.out")
              puts file
              contents = file.read
              puts contents
            end
            puts @sandbox
            @droplet.copy_resources()
            FileUtils.copy_file("/tmp/matlab/log.out", @sandbox, preserve=true)
          end
        end
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
      end

      protected

    end
  end
end
