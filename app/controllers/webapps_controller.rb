# encoding: utf-8

class WebappsController < ApplicationController

  def index
    @webapps = Webapp.all
    respond_to do |format|
      format.html
      format.json{
        render :json => @webapps.to_json
      }
    end
  end

  def new
    @webapp = Webapp.new
    @title = "Une nouvelle idée d'App?"
  end
  
  def show
    if @webapp = Webapp.find_by_id(params[:id])
      
    else
      flash[:error] = "La Webapp demandé n'existe pas"
      redirect_to accueil_path
    end
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
