caddy_site 'site' do
  servers ['http://test.com', 'https://test.com']
  tls '/etc/ssl/cert.pem /etc/ssl/key.pem'
end

caddy_site_custom 'custom' do
  data({
    'localhost:80' => {
      'log' => 'localhost.log'
    },
    'localhost:8080' => {
      'log' => 'localhost_alt.log'
    }
  })
end
