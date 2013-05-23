Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '450339965057952', 'fd39a15e4a2f5eacacfb9e4b5de9e904', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end
