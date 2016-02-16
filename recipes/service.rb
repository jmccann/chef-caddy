variables = ({
  command: '/usr/local/bin/caddy',
  options: "#{caddy_letsencrypt_arguments} -pidfile /var/run/caddy.pid -log /usr/local/caddy/caddy.log -conf #{node['caddy']['conf_dir']}/Caddyfile"
})

if %w(arch gentoo rhel fedora suse).include? node['platform_family']
  # Systemd
  template '/etc/systemd/system/caddy.service' do
    source 'systemd.erb'
    mode '0755'
    variables variables
  end
elsif node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
  # Upstart
  template '/etc/init/caddy.conf' do
    source 'upstart.erb'
    mode '0644'
    variables variables
  end
else
  # SysV
  template '/etc/init.d/caddy' do
    source 'sysv.erb'
    mode '0755'
    variables variables
  end
end

service 'caddy' do
  action [:enable, :start]
  supports status: true, start: true, stop: true, restart: true
end
