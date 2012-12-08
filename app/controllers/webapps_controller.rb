# encoding: utf-8

class WebappsController < ApplicationController

  # To call method before some other methods
  before_filter :webapps_top_comment, :only =>[:index]
  before_filter :webapps_top_trend, :only => [:index]
  before_filter :webapps_promoted, :only => [ :index]
  before_filter :webapps_top_rated, :only => [:index]
  before_filter :webapps_top_shared, :only => [ :index]
  before_filter :authenticate_user!, :only => [:create, :edit, :update]


  # GET /webapps/
  def index
    # GET /tags/:tag_id/webapps/
    if (params[:tag_id])
      @tag = Tag.find_by_id(params[:tag_id])
      @webapps = Webapp.tagged_with(@tag.name)
      @subtitle = "Résultat de la recherche :  #"+@tag.name
      @nb_results = @webapps.length ;
      respond_to do |format|
        format.html {
          render :search , :layout => "pages"
        }
        format.json{
          render :json => @webapps.uniq.to_json(:methods => %w(nb_rating preview))
        }

      end
    elsif params[:order]
      n = 30
      case params[:order]
      when "recent"
        @webapps = Webapp.recent(n)
        @subtitle = "Nouveautés"
      when "trend"
        @webapps = Webapp.trend(n)
        @subtitle = "Les plus populaires"
      when "commented"
        @webapps = Webapp.most_commented(n)
        @subtitle = "Les plus commentés"
      when "rated"
        @webapps = Webapp.best_rated(n)
        @subtitle = "Les mieux notés"
      when "suggested"
        @webapps = Webapp.suggested
        @subtitle = "Nos suggestions"
      end

      @nb_results = @webapps.length ;
      render :search , :partial => "webapps/preview_website_list",:collection => @webapps, :as => :website if params[:layout] == "list"
      render :search , :partial => "webapps/preview_website_large_grid",:collection => @webapps, :as => :website if params[:layout] == "grid"
      render :search , :layout => "pages" if params[:layout] == "true"
   
      # GET /webapps/
    else
      @subtitle = "Tous les sites web"
      @webapps = Webapp.validated
      @webapps_suggest = Webapp.suggested
      @webapps_top_recent = Webapp.recent(6)
      respond_to do |format|
        format.html {
          render :layout => "home"
        }
        format.json{
          render :json => @webapps.to_json(:methods => %w(nb_rating)), :layout => "home"
        }
      end  
    end
  end


  # GET /webapps/new
  def new
    @webapp = Webapp.new
    @title = "Une nouvelle idée de sites web ?"
    #If we want apply an other layout with this method : 
    render :layout => "pages"
  end

  # GET /webapps/:id
  def show
    if @webapp = Webapp.find_by_id(params[:id])
      @webapp.image = @webapp.photo.url(:caroussel)
      @webapp.increment_nb_click(:element => "detail")
      respond_to do |format|
        format.html
        format.json{
          ## Warning here review already return A JSON TEXT so use js method eval() to convert reviews into jsonobject
          render( :json => @webapp.to_json(:methods => ["best_tags", "reviews","nb_rating"]))
        }
      end
    else
      flash[:error] = "Le site web demandé n'existe pas"
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
    if current_user.try(:admin?)
      @webapp = Webapp.find(params[:id])
      render :layout => "pages"
    else
      flash[:error] = "Vous devez être administrateur pour éditer les websites"
      redirect_to accueil_path
    end
  end


  # PUT /webapps/1
  # earPUT /webapps/1.json
  def update
    @webapp = Webapp.find(params[:id])
    respond_to do |format|
      if @webapp.update_attributes(params[:webapp])
        format.html { redirect_to accueil_path, notice: 'Les données du website ont correctement été modifiées' }
        format.json { head :no_content }
      else
        format.html { render action: "edit",:layout =>"pages" }
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

  # GET /webapps/
  def moderation
    @title = "Modération de tous les websites"
    @webapps = Webapp.all
    @subtitle = "Résultat :"
    @nb_results = @webapps.length ;
    respond_to do |format|
      format.html{
        render :layout => "pages"
      }
      format.json{
        render :json => @webapps.to_json(:methods => %w(nb_rating))
      }
    end

  end



  ## Methods TOPS

  protected
  def webapps_top_trend
    @webapps_top_trend = Webapp.trend(5)
  end

  protected
  def webapps_top_comment
    @webapps_top_comment = Webapp.most_commented(5)
  end

  protected
  def webapps_top_rated
    @webapps_top_rated = Webapp.best_rated(5)
  end

    protected
  def webapps_top_shared
    @webapps_top_shared = Webapp.best_shared(5)
  end

  def webapps_promoted
    @webapps_promoted = Webapp.promoted
  end

end
