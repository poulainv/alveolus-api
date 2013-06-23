  # encoding: utf-8

  class WebappsController < BaseController

    before_filter :user_needed!, :only => [:create, :edit, :update ,:destroy, :vote, :new]
    caches_action :index, :trend
    cache_sweeper :webapp_sweeper

    # GET /webapps OR /categories/:category_id/webapps
    def index
      @webapps = (params[:category_id]) ? Category.find(params[:category_id]).webapps.validated : Webapp.includes(:category, :comments, :user).validated
      render json: @webapps, :each_serializer => WebappLazySerializer
    end

    # GET /webapps/:id
    def show
      @webapp = Webapp.find_by_id(params[:id])
      @webapp.increment_nb_click(:element => 'detail') ## Increment number of view on detail is it useful with google analytics ?
      render json: @webapp
    end

    # GET /webapps/new
    def new
      @webapp = Webapp.new
      render :json => @webapp
    end

    # POST /webapps/
    def create
      if current_user
        tag_list  = params[:webapp].delete(:tag_list)
        @webapp  = current_user.webapps.build(params[:webapp])
        @webapp.nb_click_shared = 0 ## Is it useful ?
        @webapp.validate = false 
        if @webapp.save
          @webapp.add_tags(tag_list, current_user)
          render :json => @webapp, :status => :created
        else
          render :json => {:errors => @webapp.errors.full_messages } ,:status => :unprocessable_entity
        end
      else 
       render json: { error: "Permission denied"}, status: 401
     end
   end

    # GET /webapp/1/edit
    def edit
      @webapp = Webapp.find(params[:id])
      if current_user.try(:admin?) or current_user.id == @webapp.user_id
        # Temporary view, TODO
        @webapps = Webapp.all
        render json: @webapps
      else
       render json: { error: "Permission denied"}, status: 401
     end
   end


    # PUT /webapps/1
    def update
      @webapp = Webapp.find(params[:id])
      if current_user.try(:admin?) or current_user.id == @webapp.user_id    
        if @webapp.update_attributes(params[:webapp])
          expire_fragment %r{webapps*}
          render :json => @webapp, :status => :created
        else
         render :json => {:errors => @webapp.errors.full_messages } ,:status => :unprocessable_entity
       end
     else
       render json: { error: "Permission denied, you need to bo admin or alveole owner"}, status: 401
     end
   end

    # DELETE /webapps/1
    def destroy
      @webapp = Webapp.find(params[:id])
      if current_user.admin?
        @webapp.destroy
        respond_to do |format|
          format.html { redirect_to user_path current_user }
        end
      else
       render json: { error: "Permission denied"}, status: 401
      end
   end


   def vote
    value = params[:type] == "up" ? 1 : -1
    @webapp = Webapp.find(params[:id])
    @webapp.add_or_update_evaluation(:votes, value, current_user)
    expire_fragment %r{webapps/trend/unvalidated}
      ## Warning here there are some computation/behavior which should be in model
      if(@webapp.reputation_for(:votes)>@webapp.score_for_validation)
        @webapp.update_attribute("validate", "true")
      end
      render :json => @webapp, :serializer => WebappVoteSerializer
    end


    ## Method to increment nb_click...
    def click
      webapp = Webapp.find(params[:id])
      webapp.increment_nb_click(:element => params[:element])
      render :status => 200, :nothing => true
    end

    ## Get webapp/trend/:type(/:n)
    def trend
      n = params[:n] ? params[:n].to_i : 12
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
      when "popular"
        @webapps = Webapp.popular(n)
      when "unvalidated"
        @webapps = Webapp.unvalidated
        render json: @webapps, :each_serializer => WebappVoteSerializer
        return
      end
      render json: @webapps, :each_serializer => WebappLazySerializer
    end
  end

  def search
    if params[:search]
      query = params[:search]
      if query.length < 3
       render :json => {:errors => "Recherche trop courte", :status => :unprocessable_entity}
     else
      @webapps = Webapp.validated.where{(title =~ "%#{query}%") |  (caption =~ "%#{query}%") }
      tags = Tag.where{(name =~ "%#{query}%")}
      tags.each do |tag|
        @webapps += tag.webapps.validated
      end
      @webapps = @webapps.uniq
      render json: @webapps, :each_serializer => WebappLazySerializer
    end
  end
end


def check_url
  if params[:url]
    query = params[:url]
    if Webapp.where{url =~ "%#{query}%"}.length == 0
     render :json => {:success => "URL not already used"}, :status => 200
   else
    render :json => {:errors => "URL already used"}, :status => :unprocessable_entity
  end
else
 render :json => {:errors => "I need params 'url'"} ,:status => :unprocessable_entity
end

end

end
