class SessionsController < Devise::SessionsController
 before_filter :authenticate_user!, :except => [:create, :destroy]
  respond_to :json

  def create
    print "bonjour"
    resource = User.find_for_database_authentication(:email => params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in(:user, resource)
      resource.ensure_authentication_token!
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email, :id => resource.id}
      return
    end
    invalid_login_attempt
  end

  def destroy
    print 'bonjour'
    print params[:id]
    resource = User.find_for_database_authentication(:id => params[:id])
    resource.authentication_token = nil
    resource.save
    render :json=> {:success=>true}
  end

  protected

  def invalid_login_attempt
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end 