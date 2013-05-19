  # encoding: utf-8

    class WebappsController < BaseController

    before_filter :authenticate_user!, :only => [:create, :edit, :update ,:destroy]

    # GET /webapps
    def index
      @webapps = Webapp.all
    end

    # GET /webapps/:id/tags
    def tags
      @tags = Webapp.find(params[:id]).tags
      render json: @tags
    end

    # GET /webapps/:id/bookmarks
    def bookmarks
      @bookmarks = Webapp.find(params[:id]).bookmarks
      render json: @bookmarks
    end

    # GET /webapps/:id
    def show
    #  if current_user
    @webapp = Webapp.find_by_id(params[:id])
     # end

   end

    # GET /webapps/new
    def new
      @webapp = Webapp.new
      render :json => @webapp
    end

    # POST /webapps/
    def create
      tag_list  = params[:webapp].delete(:tag_list)
      @webapp  = current_user.webapps.build(params[:webapp])
      @webapp.nb_click_shared = 0;
      if @webapp.save
        @webapp.add_tags(tag_list, current_user)
        render :json => "ok", :status => :created
      else
        render :json => {:errors => "ok", :status => :unprocessable_entity}
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

    ## Get webapp/trend/:what
    def trend
      n = 12
      if params[:type]
       case params[:type]
       when "recent"
        @webapps = Webapp.recent(n)
      when "commented"
        @webapps = Webapp.most_commented(n)
      when "rated"
        @webapps = Webapp.best_rated(n)
      when "shared"
        @webapps = Webapp.best_shared(n)
      when "random"
        @webapps = Webapp.random(n)
      end
      render "webapps/index"
    end
  end

end
