class RegistrationsController < Devise::RegistrationsController

# load_and_authorize_resource

  def new
    super
  end

  def create
     build_resource(params[:user])
    # resource.build
    if resource.save
      sign_in(:user, resource)
      resource.ensure_authentication_token!
       render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email, :id => resource.id}
    else
      clean_up_passwords(resource)
      render :json => "Something wrong dude"
    end
  end

end
