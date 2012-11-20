Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '127106447445199', '9def34f79a81817c4cc087fb6e1d7404', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end
