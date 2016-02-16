default_action :nothing

attribute :from, kind_of: String
attribute :to, kind_of: [String, Array]
attribute :policy, kind_of: String
attribute :fail_timeout, kind_of: String
attribute :max_fails, kind_of: String
attribute :health_check, kind_of: String
attribute :proxy_headers, kind_of: [String, Array]
attribute :without, kind_of: String
attribute :except, kind_of: String

def extras? # rubocop:disable CyclomaticComplexity
  @policy || @fail_timeout || @max_fails || @health_check || @proxy_headers || @without || @except
end
