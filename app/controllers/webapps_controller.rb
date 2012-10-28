# encoding: utf-8

class WebappsController < ApplicationController
  
  def new
    @webapp = Webapp.new
    @title = "Une nouvelle idée d'App?"
  end
  
  def show 
    @webapp = Webapp.find_by_id(params[:id])
  end

  def create
    @webapp = Webapp.new(params[:webapp])
    @webapp.validate = false
    if @webapp.save
      flash[:success] = "Votre soumission a bien été prise en compte"
      redirect_to accueil_path
    else
      @title = "Une nouvelle idée d'App ?"
      render 'new'
    end
  end
  
  
end
