# encoding: utf-8

class WebappsController < ApplicationController
 
 before_filter :webapps_top_recent, :only => [:show, :index, :new, :create]

  # GET /webapps/
  def index
    @webapps = Webapp.all
    respond_to do |format|
      format.html
      format.json{
        render :json => @webapps.to_json
      }
    end
  end

  # GET /webapps/new
  def new
    @webapp = Webapp.new
    @title = "Une nouvelle idée d'App?"

    #If we want apply an other layout with this method : 
    #render :layout => "pages"
  end

  # GET /webapps/:id
  def show
    if @webapp = Webapp.find_by_id(params[:id])
      
    else
      flash[:error] = "La Webapp demandé n'existe pas"
      redirect_to accueil_path
    end
  end

  # POST /webapps/
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
  
  protected
   def webapps_top_recent
    @webapps_top_recent = Webapp.top_recent
  end

end
