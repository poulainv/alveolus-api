# encoding: utf-8


class TagsController < ApplicationController

  before_filter :authenticate_user!, :only => [:create]

  def new
  end

  # GET /tags/:id
  def show
    @tag = Tag.find(params[:id])
    render json: @tag
  end

  # GET /tags
  def index
    @tags = Tag.all
    render json: @tags
  end


  def create
    if params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        if @webapp.add_tags(params[:tag],current_user)
          render :json => @webapp.best_tags.to_json
        else
          flash[:error] = "Vous avez déjà taggué ce site"
          render :json => "", :status => 406
        end
      else
        flash[:error] = "La Webapp demandé n'existe pas"
        redirect_to accueil_path
      end
    else
      flash[:error] = "La page demandée n'existe pas"
      redirect_to accueil_path
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
