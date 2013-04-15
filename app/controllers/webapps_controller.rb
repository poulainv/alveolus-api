  # encoding: utf-8

  class WebappsController < ApplicationController

    # To call method before some other methods
    before_filter :webapps_top_comment, :only =>[:index]
    before_filter :webapps_top_trend, :only => [:index]
    before_filter :webapps_promoted, :only => [ :index]
    before_filter :webapps_top_rated, :only => [:index]
    before_filter :webapps_top_shared, :only => [ :index]
    before_filter :authenticate_user!, :only => [:create, :edit, :update ,:destroy]

    def index
      @webapps = Webapp.all
      render json: @webapps
    end

    # GET /webapps/:id/comments
    def comments
      render json: Webapp.find(params[:id]).comments
    end

    # GET /webapps/:id/tags
    def tags
      render json: Webapp.find(params[:id]).tags
    end

    # GET /webapps/:id
    def show
      @webapp = Webapp.find_by_id(params[:id])
      render json: @webapp
    end

    # GET /webapps/new
    def new
      @webapp = Webapp.new
      @title = "Un site Web à proposer ?"
      #If we want apply an other layout with this method :
      render :layout => "pages"
    end

    # POST /webapps/
    def create
      tag_list  = params[:webapp].delete(:tag_list)
      @webapp  = current_user.webapps.build(params[:webapp])
      @webapp.nb_click_shared = 0;
      if @webapp.save
        @webapp.add_tags(tag_list, current_user)
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
