source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
DM_VERSION = '~> 1.0.2'
RONIN = 'http://github.com/ronin-ruby'

gemspec

# DataMapper dependencies
gem 'dm-migrations',	DM_VERSION, :git => 'http://github.com/postmodern/dm-migrations.git', :branch => 'runner'

# DataMapper plugins
gem 'dm-is-remixable',	DM_VERSION, :git => "#{DATA_MAPPER}/dm-is-remixable.git"
gem 'dm-taggings',	'~> 0.11.0', :git => 'http://github.com/solnic/dm-taggings.git'

# Library dependencies
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"

group :development do
  gem 'rake',		'~> 0.8.7'

  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'ruby-graphviz',		'~> 0.9.10'
  gem 'dm-visualizer',		'~> 0.1.0'
  gem 'yard-contextify',	'~> 0.1.0'
  gem 'yard-parameters',	'~> 0.1.0'
  gem 'yard-dm',		'~> 0.1.1'
  gem 'yard-dm-is-predefined',	'~> 0.2.0'

  gem 'ore',		'~> 0.2.0'
  gem 'ore-tasks',	'~> 0.1.2'
  gem 'rspec',		'~> 2.0.0'
end

group :test do
  adapters = (ENV['ADAPTER'] || ENV['ADAPTERS'])
  adapters = adapters.to_s.gsub(',',' ').split(' ') - ['in_memory']

  DM_ADAPTERS = %w[sqlite3 postgres mysql oracle sqlserver]

  unless (DM_ADAPTERS & adapters).empty?
    adapters.each do |adapter|
      gem "dm-#{adapter}-adapter", DM_VERSION, :git => "#{DATA_MAPPER}/dm-#{adapter}-adapter.git"
    end
  end
end
