# encoding: utf-8


class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update, :show , :index]



  def index
    if (current.user.admin?)
      @users = User.all
      render "users/index", :layout => "pages"
    else redirect_to accueil_path, :alert => "Vous devez être administrateur pour accéder à cette page"
    end
  end

  def show
    @user = User.find(params[:id])
    # Un peu laid, passé par un parametre local plz
    @nb_results = @user.webapps_starred.length
    redirect_to users_path, :alert => "Impossible d'accéder à cet utilisteur" if @user.id!=current_user.id
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

  def destroy

    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end