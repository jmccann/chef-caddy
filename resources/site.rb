actions :create
default_action :create

attribute :servers, kind_of: [String, Array]
attribute :tls, kind_of: String

attribute :custom, kind_of: Hash

include Chef::DSL::Recipe
attr_accessor :proxy

def proxy(from_to = nil, &block)
  @proxy ||= caddy_proxy("#{@name}-proxy", &block) if block_given?

  unless from_to.nil?
    @proxy ||= caddy_proxy "#{@name}-proxy"
    @proxy.from from_to.split(' ').first
    @proxy.to from_to.split(' ')[1..-1]
  end

  @proxy.action :nothing
  @proxy
end
