Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '261681253955145', '60bfb7f71d0d28fe2ec316afeb601afc', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end
