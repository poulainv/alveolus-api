# encoding: utf-8

class WebappsController < ApplicationController

  # To call method before some other methods
  before_filter :webapps_top_recent, :only => [:show, :index]
  before_filter :webapps_top_comment, :only =>[:show, :index]
  before_filter :webapps_top_trend, :only => [:show, :index]
  before_filter :webapps_promoted, :only => [:show, :index]

  # GET /webapps/
  def index
    if (params[:tag_id])
      @tag = Tag.find_by_id(params[:tag_id])
      @webapps = Webapp.tagged_with(@tag.name)
      @subtitle = "Websites du hashtag : #"+@tag.name.capitalize
      render :search , :layout => "pages"
  
    else
      @subtitle = "Tous les websites"
      @webapps = Webapp.validated
      @webapps_suggest = Webapp.recent(6)
      @webapps_recommand = Webapp.trend(6)
      respond_to do |format|
        format.html
        format.json{
          render :json => @webapps.to_json
        }
      end
    
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
      @webapp.image = @webapp.photo.url
      respond_to do |format|
        format.html
        format.json{
          render( :json => @webapp.to_json(:include=>:comments))
        }
      end
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

  # GET /webapp/1/edit
  def edit
    @webapp = Webapp.find(params[:id])
  end


  # PUT /webapps/1
  # earPUT /webapps/1.json
  def update
    @webapp = Webapp.find(params[:id])
    respond_to do |format|
      if @webapp.update_attributes(params[:webapp])
        format.html { redirect_to @webapp, notice: 'Les données ont correctement été modifiées' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webapp.errors, status: :unprocessable_entity }
      end
    end
  end

  

  ## Method to increment nb_click...
  def click
    webapp = Webapp.find(params[:id])
    webapp.increment_nb_click(:element => params[:element])
    render :status => 200, :nothing => true
  end



  ## Methods TOPS
  protected
  def webapps_top_recent
    @webapps_top_recent = Webapp.recent(3)
  end

  protected
  def webapps_top_trend
    @webapps_top_trend = Webapp.trend(3)
  end

  protected
  def webapps_top_comment
    @webapps_top_comment = Webapp.top_comment
  end

  def webapps_promoted
    @webapps_promoted = Webapp.promoted
  end

end
