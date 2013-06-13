# encoding: utf-8


class TagsController < BaseController

  before_filter :user_needed!, :only => [:create]
  caches_action :index, :tags_all_webapps
  cache_sweeper :tag_sweeper
  def new
  end

  # GET /tags/:id
  def show
    @tag = Tag.find(params[:id])
    render json: @tag
  end

  # GET /tags OR /webapps/:webapp_id/tags
  def index
    @tags = (params[:webapp_id]) ? Webapp.find(params[:webapp_id]).tags : Tag.all
    render json: @tags
  end

  def create
    if params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        if @webapp.add_tags(params[:tag],current_user)
          render json: @webapp.best_tags.to_json
        else
          render :json => {:errors => "error"}, :status => :unprocessable_entity
        end
      else
        render :json => {:errors => "I can't find this alveoles"}, :status => :unprocessable_entity
      end
    else
      render :json => {:errors => "I neew webapp_id : alveole ID!"}, :status => :unprocessable_entity
    end
  end


  def associated
    @tag = Tag.find_by_id(params[:id])
    @tagsResult = @tag.tags_associated
    respond_to do |format|
      format.json{
        render :json => @tagsResult.to_json(:methods => %w(poid))
      }
    end
  end

    # GET /tags/all_webapps
    def tags_all_webapps
        @tags = Tag.most_posted(20)
        render json: @tags, :each_serializer => TagAllSerializer
    end


end
