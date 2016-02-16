#
# Cookbook Name:: test
# Spec:: site
#

require 'spec_helper'

describe 'test::site' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: 'caddy_site')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    context 'basic proxy config' do
      it 'contains from' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/basic_proxy.conf').with_content 'proxy / '
      end

      it 'contains to' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/basic_proxy.conf').with_content(/^  proxy .* localhost:8000 localhost:8001$/)
      end

      it 'does not have extras' do
        expect(chef_run).not_to render_file('/etc/caddy/sites.d/basic_proxy.conf').with_content(/^  proxy .* {$/)
      end
    end

    context 'proxy config with arg and block' do
      it 'contains from arg' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/proxy_arg_block.conf').with_content 'proxy / '
      end

      it 'contains to arg' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/proxy_arg_block.conf').with_content(/^  proxy .* localhost:8000 localhost:8001 {$/)
      end

      it 'contains extras from block' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/proxy_arg_block.conf').with_content(/^    max_fails 10$/)
      end
    end

    context 'advanced proxy config' do
      it 'contains from' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/advanced_proxy.conf').with_content 'proxy / '
      end

      it 'contains to' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/advanced_proxy.conf').with_content(/^  proxy .* localhost:8000 {$/)
      end

      it 'contains proxy_headers' do
        expect(chef_run).to render_file('/etc/caddy/sites.d/advanced_proxy.conf').with_content(/^    proxy_header X-Forwarded-Proto {scheme}$/)
        expect(chef_run).to render_file('/etc/caddy/sites.d/advanced_proxy.conf').with_content(/^    proxy_header X-Forwarded-For {host}$/)
        expect(chef_run).to render_file('/etc/caddy/sites.d/advanced_proxy.conf').with_content(/^    proxy_header Host {host}$/)
      end
    end
  end
end
