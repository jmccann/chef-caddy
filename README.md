# caddy Cookbook
[![Cookbook Version](https://img.shields.io/cookbook/v/caddy.svg)](https://supermarket.chef.io/cookbooks/caddy)

This cookbook installs and runs caddy webserver https://caddyserver.com


# Requirements

Chef >= 12.0.0

## cookbooks
- `ark`

# Attributes
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['caddy']['features']</tt></td>
    <td>Array</td>
    <td>features to download and install with caddy</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['caddy']['email']</tt></td>
    <td>String</td>
    <td>email to use with registration in letsencryt</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['caddy']['hosts']</tt></td>
    <td>Hash</td>
    <td>Caddyfile in form of Hash</td>
    <td><tt>{}</tt></td>
  </tr>
</table>

##### Set eMail - ['caddy']['email']
Set your eMail to register with letsencryt for HTTPS Support

##### Write your Caddyfile - ['caddy']['hosts']
```ruby
{
  'localhost:80' => {
    'log' => 'localhost.log'
  },
  'localhost:8080' => {
    'log' => 'localhost_alt.log'
  }
}
```

##### (Optional} Add features
Add features to be downloaded, e.g.
```ruby
['cors','git']
```

# Usage
## Recipes
#### caddy::default
Include `caddy::default` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[caddy::default]"
  ]
}
```

#### caddy::service
Recipe for managing caddy service.  Included in `caddy::default`.

#### caddy::\_sites_from_attributes
Helper recipe for declaring caddy_site using `node['caddy']['hosts']`.

Eventually this should be deprecated in favor of defining sites directly with `caddy_site`.

## Providers
### caddy_site
Allow specifying a site definition with directives.

#### Parameters
* `servers` - Allow specifying multiple addresses/servers that utilize the same configuration.
* `tls` - configures HTTPS connections. https://caddyserver.com/docs/tls
* `proxy` - Specify proxy for site following the [`caddy_proxy`](#caddy_proxy) resource syntax
* `custom` - Custom values for site(s) following the `node['caddy']['hosts']` syntax

#### Example
Basic definition
```ruby
caddy_site 'dev' do
  servers 'localhost:80'
  log 'localhost.log'
end

caddy_site 'dev_alt' do
  servers 'localhost:8080'
  log 'localhost_alt.log'
end
```

Passing a data structure directly to the provider
```ruby
caddy_site 'websites' do
  custom 'localhost:80' => {
           'log' => 'localhost.log'
         },
         'localhost:8080' => {
           'log' => 'localhost_alt.log'
         }
end
```

## Resources
These are **NOT** providers.  Instead they allow defining resources inside other providers.

### caddy_proxy
Based on https://caddyserver.com/docs/proxy.  Allow defining proxy settings inside a site.

#### Parameters
* `from` - the base path to match for the request to be proxied.
* `to` - the destination endpoint to proxy to. At least one is required ([String, Array]), but multiple may be specified (Array). If a scheme (http/https) is not specified, http is used.
* `policy` - the load balancing policy to use; applies only with multiple backends. May be one of random, least_conn, or round_robin. Default is random.
* `fail_timeout` - specifies how long to consider a backend as down after it has failed. While it is down, requests will not be routed to that backend. A backend is "down" if Caddy fails to communicate with it. The default value is 10 seconds ("10s").
* `max_fails` - the number of failures within fail_timeout that are needed before considering a backend to be down. If 0, the backend will never be marked as down. Default is 1.
* `health_check` - will check path on each backend. If a backend returns a status code of 200-399, then that backend is healthy. If it doesn't, the backend is marked as unhealthy for duration and no requests are routed to it. If this option is not provided then health checks are disabled. The default duration is 10 seconds ("10s").
* `proxy_headers` - sets headers to be passed to the backend. The field name is name and the value is value. This option can be specified multiple times for multiple headers, and dynamic values can also be inserted using request placeholders.

#### Examples
Basic proxy config with just to/from
```ruby
caddy_site 'basic_proxy' do
  servers ['http://test.com', 'https://test.com']
  proxy '/ localhost:8000 localhost:8001'
end
```

Proxy config specifying to/from inside block
```ruby
caddy_site 'basic_proxy' do
  servers ['http://test.com', 'https://test.com']
  proxy do
    to '/'
    from ['localhost:8000', 'localhost:8001']
  end
end
```

Proxy config with some extra parameters
```ruby
caddy_site 'basic_proxy' do
  servers ['http://test.com', 'https://test.com']
  proxy '/ localhost:8000 localhost:8001' do
    max_fails 10
  end
end
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Authors:
- Christian Fischer
- Gabriel Mazetto
