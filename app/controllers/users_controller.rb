# encoding: utf-8


class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update, :show]

  # GET /users
  def index
      @users = User.all
      render json: @users
  end

  # GET /users/:id
  def show
    if params[:id] == current_user.id or current_user.try(:admin?)
      @user = User.find(params[:id])
      render "users/show"
    end
  end


  # GET /users/:id/bookmarks
  def bookmarks
    @bookmarks = User.find(params[:id]).bookmarks
    render json: @bookmarks
  end

  def update
    @user = User.find(params[:id])
    if(current_user.try(:admin?))
      if @user.update_attributes(params[:user])
        redirect_to users_path, :notice => "Modification enregistrées"
      else
        redirect_to users_path, :alert => "Impossible d'enregistrer les modifications"
      end
    else
      if current_user.id == @user.id and @user.update_attributes(params[:user])
        redirect_to edit_user_path, :notice => "Modification enregistrées"
      else
        redirect_to edit_user_path, :alert => "Impossible d'enregistrer les modifications"
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