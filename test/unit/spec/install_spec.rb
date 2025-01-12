# Encoding: utf-8

require_relative 'spec_helper'

describe 'elasticsearch_test::tarball' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_s')
        end
      end
    end
  end
end

describe 'elasticsearch_test::tarball_v7' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_s')
        end
      end
    end
  end
end

describe 'elasticsearch_test::package' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_p')
        end
      end
    end
  end
end

describe 'elasticsearch_test::package_v7' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_p')
        end
      end
    end
  end
end

describe 'elasticsearch_test::tarball with bad version' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
            node.override['elasticsearch']['version'] = '99.99.99'
          end.converge('elasticsearch_test::tarball')
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_s')
        end
      end
    end
  end
end

describe 'elasticsearch_test::tarball with bad low version' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
            node.override['elasticsearch']['version'] = '0.0.1'
          end.converge('elasticsearch_test::tarball')
        end

        # any platform specific data you want available to your test can be loaded here
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_s')
        end
      end
    end
  end
end

describe 'elasticsearch_test::package with username foo' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      %w(repository package tarball).each do |install_type|
        context "Install Elasticsearch as #{install_type}" do
          let(:chef_run) do
            ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
              node_resources(node) # data for this node
              stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
              node.override['elasticsearch']['user']['username'] = 'foo'
              node.override['elasticsearch']['user']['groupname'] = 'bar'
              node.override['elasticsearch']['install']['type'] = install_type
            end.converge('elasticsearch_test::default_with_plugins')
          end

          # any platform specific data you want available to your test can be loaded here
          _property = load_platform_properties(platform: platform, platform_version: version)

          it 'converge status' do
            if install_type != 'tarball'
              expect { chef_run }.to raise_error(RuntimeError, /Custom usernames/)
            else
              expect { chef_run }.to_not raise_error
            end
          end
        end
      end
    end
  end
end
