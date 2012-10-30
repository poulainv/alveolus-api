class TagsController < ApplicationController
  def new
  end

  def show
    @tags = Tag.all
    respond_to do |format|
      format.html
      format.json{
        render :json => @tags.to_json
      }
    end
  end

  def associated
    @tag = Tag.find_by_id(params[:id])
    @tagsResult = @tag.tagsAssociated
    respond_to do |format|
      format.html
      format.json{
        render :json => @tagsResult.to_json
      }
    end
  end
end
