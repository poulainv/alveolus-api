# encoding: utf-8


class TagsController < BaseController

  before_filter :authenticate_user!, :only => [:create]

  def new
  end

  # GET /tags/:id
  def show
    @tag = Tag.find(params[:id])
    render "tags/show"
  end

  # GET /tags OR /webapps/:webapp_id/tags
  def index
    @tags = (params[:webapp_id]) ? Webapp.find(params[:webapp_id]).tags : Tag.all
    render "tags/index"
  end

  def create
    if params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        if @webapp.add_tags(params[:tag],current_user)
          render :json => @webapp.best_tags.to_json
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

end
