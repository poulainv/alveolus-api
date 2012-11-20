# encoding: utf-8


class AuthenticationsController < ApplicationController

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Vous vous êtes correctement authentifié"
 #     authentication.user.facebook.feed!(
  #     :message => 'Hello, Facebook!',
   #   :name => 'My Rails 3 App with Omniauth, Devise and FB_graph'
    #    )
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
      flash[:notice] = "Vous vous êtes correctement authentifié"
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      print "VINCENTTTT"+ user.email.to_s
      print "VINCENTTTT"+ user.id.to_s
      print "VINCENTTTT er"+ user.errors.full_messages.to_sentence
      if user.save
        print "je passe"
        flash[:notice] = "Vous vous êtes correctement enregistré"
        sign_in_and_redirect(:user, user)
      else
         print "VINCENTTTT err"+ user.errors.full_messages.to_sentence
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
