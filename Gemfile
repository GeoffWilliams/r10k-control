source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 3.3']
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 0.8.2'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'beaker-rspec', '>= 5.2.2'
gem 'pry', '>= 0.10.1'
#gem 'beaker', '2.25.0'

# Example of how to run against local beaker sourcecode
#gem 'beaker', :path => '~/github/beaker'

# Example of how to checkout from git
gem 'beaker', :git => 'https://github.com/geoffwilliams/beaker', :branch => 'scp_dotfiles'
