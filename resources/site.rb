actions :create
default_action :create

attribute :servers, kind_of: [String, Array]
# attribute :proxy, kind_of: String
attribute :tls, kind_of: String

attribute :custom, kind_of: Hash

include Chef::DSL::Recipe
attr_accessor :proxy

def proxy(&block)
  @proxy ||= caddy_proxy("#{@name}-proxy", &block)
  @proxy.action :nothing
  @proxy
end
