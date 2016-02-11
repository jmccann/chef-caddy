use_inline_resources

action :create do
  run_context.include_recipe 'caddy::service'

  directory "#{node['caddy']['conf_dir']}/sites.d"

  template "#{node['caddy']['conf_dir']}/sites.d/#{new_resource.name}.conf" do
    cookbook 'caddy'
    source 'site.erb'
    variables(
      custom: new_resource.custom
    )
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[caddy]', :delayed
  end

  site_files = include_files
  template "#{node['caddy']['conf_dir']}/Caddyfile" do
    cookbook 'caddy'
    source 'Caddyfile.erb'
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
  # Check for >= Chef 12
  return true if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('12.0.0') && resource.declared_type == new_resource.declared_type

  # Check for <= Chef 11
  return true if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.0.0') && resource.resource_name == new_resource.resource_name

  false
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
