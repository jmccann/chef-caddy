caddy_site 'basic' do
  log 'basic.log'
end

caddy_site 'basic_proxy' do
  servers ['http://test.com', 'https://test.com']
  tls '/etc/ssl/cert.pem /etc/ssl/key.pem'
  proxy '/ localhost:8000 localhost:8001'
end

caddy_site 'proxy_arg_block' do
  servers ['http://test.com', 'https://test.com']
  tls '/etc/ssl/cert.pem /etc/ssl/key.pem'
  proxy '/ localhost:8000 localhost:8001' do
    max_fails 10
  end
end


caddy_site 'advanced_proxy' do
  servers ['http://test.com', 'https://test.com']
  tls '/etc/ssl/cert.pem /etc/ssl/key.pem'
  proxy do
    from '/'
    to 'localhost:8000'
    proxy_headers ['X-Forwarded-Proto {scheme}', 'X-Forwarded-For {host}', 'Host {host}']
  end
end
