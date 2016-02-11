# caddy Cookbook
[![Cookbook Version](https://img.shields.io/cookbook/v/caddy.svg)](https://supermarket.chef.io/cookbooks/caddy)

This cookbook installs and runs caddy webserver https://caddyserver.com


# Requirements
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
#### Parameters
`custom` - Custom values for site(s) following the `node['caddy']['hosts']` syntax

#### Example
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
