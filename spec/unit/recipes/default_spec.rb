#
# Cookbook Name:: caddy
# Spec:: default
#

require 'spec_helper'

describe 'caddy::default' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'creates Caddyfile' do
      expect(chef_run).to create_template '/etc/Caddyfile'
    end

    context "node['caddy']['hosts'] is populated" do
      cached(:chef_run) do
        runner = ChefSpec::ServerRunner.new do |node, _server|
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

      it 'populates Caddyfile with site entries' do
        expect(chef_run).to render_file('/etc/Caddyfile').with_content "localhost:80  {\n  log localhost.log\n}\nlocalhost:8080  {\n  log localhost_alt.log\n}"
      end
    end
  end
end
