  # encoding: utf-8

    class WebappsController < BaseController

    before_filter :user_needed!, :only => [:create, :edit, :update ,:destroy, :vote]

    # GET /webapps OR /categories/:category_id/webapps
    def index
      @webapps = (params[:category_id]) ? Category.find(params[:category_id]).webapps : Webapp.all
    end

    # GET /webapps/:id
    def show
      #  if current_user
      @webapp = Webapp.find_by_id(params[:id])
      render "webapps/show"
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
      @webapp.nb_click_shared = 0
      @webapp.validate = false 
      if @webapp.save
        @webapp.add_tags(tag_list, current_user)
        render :json => @webapp, :status => :created
      else
        render :json => {:errors => @webapp.errors.full_messages } ,:status => :unprocessable_entity
      end
    end

    # GET /webapp/1/edit
    def edit
      @webapp = Webapp.find(params[:id])
      if current_user.try(:admin?) or current_user.id == @webapp.user_id
        # Temporary view, TODO
        render "index"
      else
        render :json => {:errors => @webapp.errors.full_messages } ,:status => :unprocessable_entity
      end
    end


    # PUT /webapps/1
    def update
      @webapp = Webapp.find(params[:id])
      # if current_user.try(:admin?) or (current_user.id == @webapp.user_id and @webapp.validate == false)
      
        if @webapp.update_attributes(params[:webapp])
          render :json => @webapp, :status => :created
        else
         render :json => {:errors => @webapp.errors.full_messages } ,:status => :unprocessable_entity
        end
      
      # end
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

    ## Get webapp/trend/:type
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
      when "unvalidated"
        @webapps = Webapp.unvalidated
        # render :json => @webapps.to_json(:methods => %w(count_negative count_positive))
        render "webapps/show-with-vote"
        return
      end
      render "webapps/index"
    end
  end

  def search
    if params[:search]
      query = params[:search]
      if query.length < 3
           render :json => {:errors => "search too short", :status => :unprocessable_entity}
      else
        @webapps = Webapp.validated.where{(title =~ "%#{query}%") |  (caption =~ "%#{query}%") }
        tags = Tag.where{(name =~ "%#{query}%")}
        tags.each do |tag|
          @webapps += tag.webapps
        end
        @webapps = @webapps.uniq
        render "webapps/index"
      end
    end
  end
end
