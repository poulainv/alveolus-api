# encoding: utf-8

class WebappsController < ApplicationController

  # To call method before some other methods
  before_filter :webapps_top_comment, :only =>[:index]
  before_filter :webapps_top_trend, :only => [:index]
  before_filter :webapps_promoted, :only => [ :index]
  before_filter :webapps_top_rated, :only => [:index]
  before_filter :webapps_top_shared, :only => [ :index]
  before_filter :authenticate_user!, :only => [:create, :edit, :update ,:destroy]


  # GET /webapps/
  def index
    # GET /tags/:tag_id/webapps/
    if (params[:tag_id])
      @tag = Tag.find_by_id(params[:tag_id])
      @webapps = Webapp.tagged_with(@tag.name).uniq
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
      n = 12
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
        @subtitle = "Notre sélection"
      when "random"
        @webapps = Webapp.random(n)
        @subtitle = "Aléatoire"
      when "unvalidated"
        @webapps = Webapp.unvalidated
        @subtitle = "Sites Web non-validés"
        render :vote
        return;
      when "moderate"
        if(current_user.try(:admin?))
          @webapps = Webapp.all
          @subtitle = "Tous"
        else
          flash[:error] = "Les droits d'administrateurs sont nécessaires"
          redirect_to accueil_path
          return;
        end
      end

      @nb_results = @webapps.length ;
      render :search , :partial => "webapps/preview_website_list",:collection => @webapps, :as => :website if params[:layout] == "list"
      render :search , :partial => "webapps/preview_website_large_grid",:collection => @webapps, :as => :website if params[:layout] == "grid"
      render :search , :layout => "pages" if params[:layout] == "true"

      ## SEARCH
    elsif params[:search]
      query = params[:search]
      if query.length < 3
        flash[:error] = "Veuillez entrer au moins 3 caractères"
        redirect_to accueil_path
      else
        @webapps = Webapp.validated.where{(title =~ "%#{query}%") |  (caption =~ "%#{query}%") }
        tags = Tag.where{(name =~ "%#{query}%")}
        tags.each do |tag|
          @webapps += tag.webapps
        end
        @webapps = @webapps.uniq
        @nb_results = @webapps.length
        @subtitle = "Résultat de la recherche : "+params[:search]
        respond_to do |format|
          format.html {
            render :search , :layout => "pages"
          }
          format.json {
            render :json => @webapps.to_json
          }
        end
      end

    # GET /webapps/
  else
    @subtitle = "Tous les sites Web"
    @webapps = Webapp.validated
    @webapps_suggest = Webapp.suggested
    @webapps_top_recent = Webapp.recent(10)
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
  @title = "Un site Web à proposer ?"
  #If we want apply an other layout with this method :
  render :layout => "pages"
end

# GET /webapps/:id
def show
  if @webapp = Webapp.find_by_id(params[:id])
    render :layout => false
  else
    flash[:error] = "Le site web demandé n'existe pas"
    redirect_to accueil_path
  end
end
  
# POST /webapps/
def create
  @webapp  = current_user.webapps.build(params[:webapp])
  
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
  if current_user.try(:admin?) or current_user.id == @webapp.user_id
    render :layout => "pages"
  else
    flash[:error] = "Vous devez être administrateur pour éditer les websites ou bien l'utilisateur à l'initiative de cette suggestion."
    redirect_to accueil_path
  end
end


# PUT /webapps/1
# earPUT /webapps/1.json
def update
  @webapp = Webapp.find(params[:id])
  if current_user.try(:admin?) or (current_user.id == @webapp.user_id and @webapp.validate == false)
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
end

# DELETE /webapps/1
def destroy
  @webapp = Webapp.find(params[:id])
  if current_user.admin? or (@webapp.user_id == current_user.id and @webapp.validate == false)
    @webapp.destroy
    respond_to do |format|
      format.html { redirect_to user_path current_user }
    end
  else
    redirect_to accueil_ath, notice: "Action non autorisée"
  end
end


def vote
  value = params[:type] == "up" ? 1 : -1
  @webapp = Webapp.find(params[:id])
  @webapp.add_or_update_evaluation(:votes, value, current_user)

  ## Warning here there are some computation/behavior which should be in model
  if(@webapp.reputation_for(:votes)>@webapp.score_for_validation)
    @webapp.update_attribute("validate", "true")
  end
  render :json => @webapp.to_json(:methods => %w(count_negative count_positive))
end


## Method to increment nb_click...
def click
  webapp = Webapp.find(params[:id])
  webapp.increment_nb_click(:element => params[:element])
  render :status => 200, :nothing => true
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
