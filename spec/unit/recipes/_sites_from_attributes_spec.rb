#
# Cookbook Name:: caddy
# Spec:: _sites_from_attributes
#

require 'spec_helper'

describe 'caddy::_sites_from_attributes' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: 'caddy_site')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'creates Caddyfile' do
      expect(chef_run).to create_template '/etc/caddy/Caddyfile'
    end

    context "node['caddy']['hosts'] is populated" do
      cached(:chef_run) do
        runner = ChefSpec::ServerRunner.new(step_into: 'caddy_site') do |node, _server|
          node.set['caddy']['hosts'] = {
            'localhost:80' => {
              'log' => 'localhost.log'
            },
            'localhost:8080' => {
              'log' => 'localhost_alt.log'
            }
          }
        end
        runner.converge(described_recipe)
      end

      it 'creates Caddyfile with site entry' do
        expect(chef_run).to create_template('attribute_driven: Caddyfile').with(path: '/etc/caddy/Caddyfile')
        expect(chef_run).to render_file('/etc/caddy/Caddyfile').with_content 'import /etc/caddy/sites.d/attribute_driven.conf'
      end

      it 'creates subconfig with site entries' do
        expect(chef_run).to create_template('attribute_driven site config').with(path: '/etc/caddy/sites.d/attribute_driven.conf')
        expect(chef_run).to render_file('/etc/caddy/sites.d/attribute_driven.conf').with_content "localhost:80  {\n  log localhost.log\n}\nlocalhost:8080  {\n  log localhost_alt.log\n}"
      end
    end
  end
end
