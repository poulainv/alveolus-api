class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :null_session
  #http_basic_authenticate_with :name => "admin", :password => "quenelle"

   # do not use CSRF for CORS options
  skip_before_filter :verify_authenticity_token, :only => [:options]

  before_filter :cors_set_access_control_headers


  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*, X-Requested-With, X-Prototype-Version, X-CSRF-Token, Content-Type'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def options 
    render :text => '', :content_type => 'text/plain'
  end

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
end
