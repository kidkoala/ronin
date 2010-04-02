require 'rubygems'
require 'rake'
require './lib/ronin/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ronin'
    gem.version = Ronin::VERSION
    gem.licenses = ['GPL-2']
    gem.summary = %Q{A Ruby platform for exploit development and security research.}
    gem.description = %Q{Ronin is a Ruby platform for exploit development and security research. Ronin allows for the rapid development and distribution of code, exploits or payloads over many common Source-Code-Management (SCM) systems.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/ronin-ruby/ronin'
    gem.authors = ['Postmodern']
    gem.add_dependency 'nokogiri', '~> 1.3.3'
    gem.add_dependency 'extlib', '~> 0.9.14'
    gem.add_dependency 'data_objects', '~> 0.10.1'
    gem.add_dependency 'do_sqlite3', '~> 0.10.1'
    gem.add_dependency 'dm-core', '~> 0.10.2'
    gem.add_dependency 'dm-types', '~> 0.10.2'
    gem.add_dependency 'dm-validations', '~> 0.10.2'
    gem.add_dependency 'dm-aggregates', '~> 0.10.2'
    gem.add_dependency 'dm-predefined', '~> 0.2.3'
    gem.add_dependency 'open-namespace', '~> 0.1.0'
    gem.add_dependency 'static_paths', '~> 0.1.0'
    gem.add_dependency 'contextify', '~> 0.1.5'
    gem.add_dependency 'pullr', '~> 0.1.2'
    gem.add_dependency 'thor', '~> 0.13.0'
    gem.add_dependency 'thin', '~> 1.2.5'
    gem.add_dependency 'rack', '~> 1.0.0'
    gem.add_dependency 'sinatra', '~> 0.9.4'
    gem.add_dependency 'ronin-ext', '~> 0.1.0'
    gem.add_development_dependency 'rspec', '~> 1.3.0'
    gem.add_development_dependency 'yard', '~> 0.5.3'
    gem.add_development_dependency 'yard-dm', '~> 0.1.1'
    gem.add_development_dependency 'yard-dm-predefined', '~> 0.1.0'
    gem.has_rdoc = 'yard'

    gem.post_install_message = %{
    Thank you for installing Ronin, a Ruby platform for exploit development
    and security research. To list the available commands:

      $ ronin help

    To jump into the Ronin Ruby Console:

      $ ronin

    To start up the local Ronin Web UI, run the follwoing command and
    go to http://localhost:3030/:

      $ ronin webapp

    Additional functionality can be added to Ronin by installing additional
    libraries:
    * ronin-asm
    * ronin-dorks
    * ronin-exploits
    * ronin-gen
    * ronin-int
    * ronin-php
    * ronin-scanners
    * ronin-sql
    * ronin-web
    }
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
