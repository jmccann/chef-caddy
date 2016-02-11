#
# Cookbook Name:: caddy
# Recipe:: default
#
# Copyright 2015, computerlyrik, Christian Fischer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Conventions
# caddy install dir at /usr/local/caddy
# log at /usr/local/caddy/caddy.log
# Caddyfile at /etc/caddy/Caddyfile
# pidfile at /var/run/caddy.pid

ark 'caddy' do
  url "https://caddyserver.com/download/build?os=linux&arch=amd64&features=#{node['caddy']['features'].join(',')}"
  extension 'tar.gz'
  has_binaries ['./caddy']
  strip_components 0
  notifies :restart, 'service[caddy]'
end

execute 'setcap cap_net_bind_service=+ep caddy' do
  cwd '/usr/local/caddy'
  action :nothing
  subscribes :run, 'ark[caddy]', :immediately
end

directory node['caddy']['conf_dir']

include_recipe 'caddy::_sites_from_attributes'

include_recipe 'caddy::service'
