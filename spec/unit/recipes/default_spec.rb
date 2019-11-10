#
# Cookbook:: elk_stack
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'elk_stack::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on CentOS 7' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'centos', '7'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs a package' do
      expect(chef_run).to install_package('elasticsearch-7.4.1-1')
    end

    it 'installs a package' do
      expect(chef_run).to install_package('logstash-7.4.1-1')
    end

    it 'installs a package' do
      expect(chef_run).to install_package('kibana-7.4.1-1')
    end

    it 'installs a package' do
      expect(chef_run).to install_package('java-1.8.0-openjdk')
    end
  end
end
