# encoding: utf-8


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



  def index
    if params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        render :json => @webapp.best_tags(3).to_json(:include => :tagAppRelations)
      else
        flash[:error] = "La Webapp demandé n'existe pas"
        redirect_to accueil_path
      end
    else
      flash[:error] = "URL inconnue"
      redirect_to accueil_path
    end
  end

  ################
  ## Manage TAG ##
  ################
  def create
    if params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        @webapp.add_tags(params[:tag])
        render :json => @webapp.best_tags(3).to_json
      else
        flash[:error] = "La Webapp demandé n'existe pas"
        redirect_to accueil_path
      end
    end
  end


  def associated
    @tag = Tag.find_by_id(params[:id])
    @tagsResult = @tag.tags_associated
    respond_to do |format|
      format.json{
        render :json => @tagsResult.to_json
      }
    end
  end

end
