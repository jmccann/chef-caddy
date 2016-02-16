use_inline_resources

action :create do
  run_context.include_recipe 'caddy::service'

  directory "#{new_resource.name} sites.d directory" do
    path "#{node['caddy']['conf_dir']}/sites.d"
  end

  template "#{new_resource.name} site config" do
    cookbook 'caddy'
    source 'site.erb'
    path "#{node['caddy']['conf_dir']}/sites.d/#{new_resource.name}.conf"
    variables resource: new_resource
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[caddy]', :delayed
  end

  site_files = include_files
  template "#{new_resource.name}: Caddyfile" do
    cookbook 'caddy'
    source 'Caddyfile.erb'
    path "#{node['caddy']['conf_dir']}/Caddyfile"
    owner 'root'
    group 'root'
    mode 0644
    variables(files: site_files)
    notifies :restart, 'service[caddy]', :delayed
  end
end

private

#
# Determine if the resource matches this resource's type
#
# @param resource the resource to check
#
# @return [TrueClass, FalseClass] wether or not the resource matches
#
def resource_match?(resource)
  [:caddy_site, :caddy_site_custom].include? resource.declared_type
end

#
# List of files to include in list.conf for a collection of subconfigs
#
# @return [Array<String>] An array of config files for the subconfig
def include_files
  run_context.resource_collection.map do |resource|
    next unless resource_match? resource
    next unless resource.action == :create || resource.action.include?(:create)
    "#{node['caddy']['conf_dir']}/sites.d/#{resource.name}.conf"
  end.compact
end
