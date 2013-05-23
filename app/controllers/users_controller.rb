# encoding: utf-8


class UsersController < BaseController

  before_filter :authenticate_user!, :only => [:edit, :update]

  # GET /users
  def index
      @users = User.all
      render json: @users
  end

  # GET /users/:id
  def show
    if params[:id].to_i == current_user.id || current_user.try(:admin?)
      @user = User.find(params[:id])
      render "users/show"
    end
  end

  def update
    @user = User.find(params[:id])
    if(current_user.try(:admin?))
      if @user.update_attributes(params[:user])
         render "users/show"
      else
         render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
      end
    else
      if current_user.id == @user.id and @user.update_attributes(params[:user])
         render "users/show"
      else
         render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    render :layout => "pages"
  end

  # def destroy
  #   user = User.find(params[:id])
  #   unless user == current_user
  #     user.destroy
  #     redirect_to users_path, :notice => "User deleted."
  #   else
  #     redirect_to users_path, :notice => "Can't delete yourself."
  #   end
  # end
end