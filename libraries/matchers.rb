if defined?(ChefSpec)
  ChefSpec.define_matcher :caddy_site

  def create_caddy_site(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:caddy_site, :create, resource_name)
  end
end
