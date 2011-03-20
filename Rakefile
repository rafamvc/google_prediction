# Copyright (C) 2010 Google Inc.
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

require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

task :default => [:test]

task :test do
  ruby "test/test_google_prediction.rb"
end

task :doc do
  system "rdoc"
end

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.author = 'Brandon Liu'
  s.email = 'bdon@google.com'
  s.homepage = 'http://code.google.com/p/ruby-google-prediction-api'
  s.summary = "Google Prediction API Ruby Library"
  s.rubyforge_project = 'google_prediction'
  s.name = 'google_prediction'
  s.version = '0.0.1'
  s.add_dependency('gdata', '>= 1.1.1')
  s.add_dependency('activesupport', '>= 2.3.2')
  s.require_path = 'lib'
  s.requirements = 'Training data on Google Storage'
  s.test_files = FileList['test/test_google_prediction.rb']
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.rdoc_options << '--main' << 'README'
  s.files = FileList.new('[A-Z]*', 'lib/**/*.rb', 'test/**/*')
  s.description = <<EOF
This gem provides a wrapper around the Google Prediction API.
EOF
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end