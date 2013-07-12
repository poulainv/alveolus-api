# encoding: utf-8


class UsersController < BaseController

  before_filter :user_needed!, :only => [:show, :edit, :update, :update_password]

  # GET /users
  def index
    if (current_user.try(:admin?))
      @users = User.all
      render json: @users, :each_serializer => UserLazySerializer
    else
      render json: { error: "Permission denied"}, status: 401

    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # PUT users/:id
  def update
    @user = User.find(params[:id])
    if(current_user.try(:admin?))
      if @user.update_attributes(params[:user])
       render json: @user
     else
       render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
     end
   else
    if current_user.id == @user.id and @user.update_attributes(params[:user])
      render json: @user
    else
      render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end
end

  # PUT users/:id/update_password
  def update_password
    @user = User.find(params[:id])
    if current_user.id == @user.id and @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      render json: @user
    else
      render :json => {:errors => "Wrong current password or password confirmation"}, :status => :unprocessable_entity
    end
  end

  def edit
   if params[:id].to_i == current_user.id || current_user.try(:admin?)
    @user = User.find(params[:id])
    render json: @user, :serializer => UserEditSerializer 
  end
end

def destroy
  user = User.find(params[:id])
  if (current_user.try(:admin?) or user ==curent_user)   
    user.destroy
    render json: {success => "User deleted"}, :status => 200
  else
    render json: {Error => "You have to be admin or current user"}, :status => 401
  end

end
end