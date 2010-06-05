source 'http://rubygems.org'
datamapper = 'git://github.com/datamapper'
ronin_ruby = 'git://github.com/ronin-ruby'

group :runtime do
  gem 'nokogiri',	'~> 1.4.1'
  gem 'activesupport',	'~> 3.0.0.beta3'

  # DataMapper adapters
  gem 'dm-do-adapter',		'~> 1.0.0.rc3', :git => "#{datamapper}/dm-do-adapter.git"
  gem 'dm-sqlite-adapter',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-sqlite-adapter.git"

  # DataMapper dependencies
  gem 'dm-core',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-core.git"
  gem 'dm-types',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-types.git"
  gem 'dm-constraints',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-constraints.git"
  gem 'dm-migrations',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-migrations.git"
  gem 'dm-validations',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-validations.git"
  gem 'dm-aggregates',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-aggregates.git"
  gem 'dm-timestamps',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-timestamps.git"
  gem 'dm-tags',	'~> 1.0.0.rc3', :git => "#{datamapper}/dm-tags.git"

  # DataMapper plugins
  gem 'dm-is-predefined',	'~> 0.3.0', :git => 'git://github.com/postmodern/dm-is-predefined.git'

  gem 'open_namespace',	'~> 0.3.0'
  gem 'parameters',	'~> 0.2.1'
  gem 'data_paths',	'~> 0.2.1'
  gem 'contextify',	'~> 0.1.6'
  gem 'pullr',		'~> 0.1.2'
  gem 'thor',		'~> 0.13.0'
  gem 'ronin-support',	'~> 0.1.0', :git => "#{ronin_ruby}/ronin-support.git"
end

group :development do
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.4.0', :git => 'git://github.com/technicalpickles/jeweler.git'
end

group :doc do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'ruby-graphviz',		'~> 0.9.10'
  gem 'dm-visualizer',		'~> 0.1.0'
  gem 'yard',			'~> 0.5.3'
  gem 'yard-contextify',	'~> 0.1.0'
  gem 'yard-parameters',	'~> 0.1.0'
  gem 'yard-dm',		'~> 0.1.1'
  gem 'yard-dm-is-predefined',	'~> 0.2.0', :git => 'git://github.com/postmodern/yard-dm-is-predefined.git'
end

gem 'rspec',	'~> 1.3.0', :group => [:development, :test]
