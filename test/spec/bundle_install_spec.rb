#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'
require 'poise_application_ruby/bundle_install'
require 'poise_application_ruby/error'

describe PoiseApplicationRuby::BundleInstall do
  describe PoiseApplicationRuby::BundleInstall::Resource do
  end # /describe PoiseApplicationRuby::BundleInstall::Resource

  describe PoiseApplicationRuby::BundleInstall::Provider do
    describe '#gem_bin' do
      let(:new_resource) { double(absolute_gem_binary: '/usr/local/bin/gem') }
      let(:provider) { described_class.new(new_resource, nil) }
      let(:gem_environment) { '' }
      subject { provider.send(:gem_bindir) }
      before do
        expect(provider).to receive(:shell_out!).and_return(double(stdout: gem_environment))
      end

      context 'with an Ubuntu 14.04 gem environment' do
        let(:gem_environment) { <<-EOH }
RubyGems Environment:
  - RUBYGEMS VERSION: 1.8.23
  - RUBY VERSION: 1.9.3 (2013-11-22 patchlevel 484) [x86_64-linux]
  - INSTALLATION DIRECTORY: /var/lib/gems/1.9.1
  - RUBY EXECUTABLE: /usr/bin/ruby1.9.1
  - EXECUTABLE DIRECTORY: /usr/local/bin
  - RUBYGEMS PLATFORMS:
    - ruby
    - x86_64-linux
  - GEM PATHS:
     - /var/lib/gems/1.9.1
     - /root/.gem/ruby/1.9.1
  - GEM CONFIGURATION:
     - :update_sources => true
     - :verbose => true
     - :benchmark => false
     - :backtrace => false
     - :bulk_threshold => 1000
  - REMOTE SOURCES:
     - http://rubygems.org/
EOH
        it { is_expected.to eq '/usr/local/bin' }
      end # /context Ubuntu 14.04 gem environment

      context 'with an rbenv gem environment' do
        let(:gem_environment) { <<-EOH }
RubyGems Environment:
  - RUBYGEMS VERSION: 2.2.2
  - RUBY VERSION: 2.1.2 (2014-05-08 patchlevel 95) [x86_64-darwin13.0]
  - INSTALLATION DIRECTORY: /Users/asmithee/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0
  - RUBY EXECUTABLE: /Users/asmithee/.rbenv/versions/2.1.2/bin/ruby
  - EXECUTABLE DIRECTORY: /Users/asmithee/.rbenv/versions/2.1.2/bin
  - SPEC CACHE DIRECTORY: /Users/asmithee/.gem/specs
  - RUBYGEMS PLATFORMS:
    - ruby
    - x86_64-darwin-13
  - GEM PATHS:
     - /Users/asmithee/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0
     - /Users/asmithee/.gem/ruby/2.1.0
  - GEM CONFIGURATION:
     - :update_sources => true
     - :verbose => true
     - :backtrace => false
     - :bulk_threshold => 1000
     - "gem" => "--no-ri --no-rdoc"
  - REMOTE SOURCES:
     - https://rubygems.org/
  - SHELL PATH:
     - /Users/asmithee/.rbenv/versions/2.1.2/bin
     - /usr/local/opt/rbenv/libexec
     - /Users/asmithee/.rbenv/shims
     - /usr/local/opt/rbenv/bin
     - /opt/vagrant/bin
     - /Users/asmithee/.rbcompile/bin
     - /usr/local/share/npm/bin
     - /usr/local/share/python
     - /usr/local/bin
     - /usr/bin
     - /bin
     - /usr/sbin
     - /sbin
     - /usr/local/bin
     - /usr/local/MacGPG2/bin
     - /usr/texbin
EOH
        it { is_expected.to eq '/Users/asmithee/.rbenv/versions/2.1.2/bin' }
      end # /context rbenv gem environment

      context 'with no executable directory' do
        it { expect { subject }.to raise_error(PoiseApplicationRuby::Error) }
      end # /context with no executable directory

    end # /describe #gem_bin
  end # /describe PoiseApplicationRuby::BundleInstall::Provider
end
