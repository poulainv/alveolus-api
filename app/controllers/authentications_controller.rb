# encoding: utf-8


class AuthenticationsController < BaseController

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
   
    if authentication
      user = authentication.user
      sign_in(:user, user)
      user.ensure_authentication_token!
      render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email, :id => user.id}
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
      sign_in(:user, user)
      user.ensure_authentication_token!
      render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email, :id => user.id}
    else
      user = User.new
      user.apply_omniauth(omniauth)
      # user.skip_confirmation!
      if user.save
        sign_in(:user, user)
        user.ensure_authentication_token!
        render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email, :id => user.id}
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
