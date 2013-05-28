# encoding: utf-8


class FacebooksController < BaseController

  def fetch
    access_token = params['accessToken']

    begin
      user_fb = FbGraph::User.me(access_token).fetch
    rescue => the_error
      @error = the_error.message
      puts "Error #{the_error.message}"
    end

    if user_fb && user_fb.email

        user = User.find_by_email(user_fb.email)

        if user
          sign_in(:user, user)
          user.ensure_authentication_token!
          render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email, :id => user.id}
        else
             user = User.new(:email =>user_fb.email, :password => access_token[1..10], :password_confirmation => access_token[1..10])
            if user.save
              sign_in(:user, user)
              user.ensure_authentication_token!
              render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email, :id => user.id}
            else
              render :json => {:success => user.errors.full_messages}, :status => 401
            end
        end


        
    end
  end

end
