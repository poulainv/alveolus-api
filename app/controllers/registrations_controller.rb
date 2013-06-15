class RegistrationsController < Devise::RegistrationsController

# load_and_authorize_resource

  def new
    super
  end

  def create
     build_resource(params[:user])
    # resource.build
    if resource.save
      resource.update_attribute(:pseudo,"alveoler"+resource.id.to_s)
      # sign_in(:user, resource)
      resource.ensure_authentication_token!
       # render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email, :id => resource.id}
        render :json => {:success => "Wait for confirmation"}
    else
      clean_up_passwords(resource)
      render :json => {:error => resource.errors.full_messages}, :status => 422
    end
  end

end
