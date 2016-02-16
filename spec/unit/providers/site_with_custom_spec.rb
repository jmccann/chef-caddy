#
# Cookbook Name:: test
# Spec:: site_with_custom
#

require 'spec_helper'

describe 'test::site_with_custom' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: ['caddy_site', 'caddy_site_custom'])
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'create Caddyfile that includes caddy_site and caddy_site_custom' do
      expect(chef_run).to render_file('/etc/caddy/Caddyfile').with_content 'import /etc/caddy/sites.d/site.conf'
      expect(chef_run).to render_file('/etc/caddy/Caddyfile').with_content 'import /etc/caddy/sites.d/custom.conf'
    end

    context 'caddy_site' do
      let(:content) do
        'http://test.com, https://test.com {
  tls /etc/ssl/cert.pem /etc/ssl/key.pem
}'
      end

      it 'creates subconfig' do
        expect(chef_run).to create_template 'site site config'
        expect(chef_run).to render_file('/etc/caddy/sites.d/site.conf').with_content content
      end
    end

    context 'caddy_site_custom' do
      let(:content) do
        'localhost:80  {
  log localhost.log
}
localhost:8080  {
  log localhost_alt.log
}'
      end

      it 'creates subconfig' do
        expect(chef_run).to create_template 'custom subconfig'
        expect(chef_run).to render_file('/etc/caddy/sites.d/custom.conf').with_content content
      end
    end
  end
end
