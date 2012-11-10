# encoding: utf-8

class WebappsController < ApplicationController

  # To call method before some other methods
  before_filter :webapps_top_recent, :only => [:show, :index, :new, :create]
  before_filter :webapps_top_comment, :only => [:show, :index, :new, :create]
  before_filter :webapps_top_trend, :only => [:show, :index, :new, :create]

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
    @title = "Une nouvelle idée de Website?"

    #If we want apply an other layout with this method : 
    render :layout => "pages"
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
      @title = "Une nouvelle idée de Website ?"
      render :layout => "pages", :action => "new"
    end
  end

  ## Methods TOPS
  protected
  def webapps_top_recent
    @webapps_top_recent = Webapp.top_recent
  end

  protected
  def webapps_top_trend
    @webapps_top_trend = Webapp.top_trend
  end

  protected
  def webapps_top_comment
    @webapps_top_comment = Webapp.top_comment
  end

end
