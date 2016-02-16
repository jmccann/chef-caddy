actions :create
default_action :create

attribute :servers, kind_of: [String, Array], name_attribute: true
attribute :tls, kind_of: String
attribute :log, kind_of: String

include Chef::DSL::Recipe
attr_accessor :proxy

def proxy(from_to = nil, &block) # rubocop:disable AbcSize
  return @proxy if from_to.nil? && !block_given?

  @proxy ||= caddy_proxy("#{@name}-proxy", &block) if block_given?

  unless from_to.nil?
    @proxy ||= caddy_proxy "#{@name}-proxy"
    @proxy.from from_to.split(' ').first
    @proxy.to from_to.split(' ')[1..-1]
  end

  @proxy.action :nothing
  @proxy
end
