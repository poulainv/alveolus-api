# encoding: utf-8


class CommentsController < ApplicationController

  before_filter :authenticate_user! , :only => [:create, :update, :destroy]

  def index

    # GET Comment for user/webapp/
    if params[:webapp_id] and params[:user_id] and user_signed_in?
      if @comment = Comment.find_by_webapp_id_and_user_id( params[:webapp_id], current_user.id)
        respond_to do |format|
          format.html
          format.json{
            ## Warning here review already return A JSON TEXT so use js method eval() to convert reviews into jsonobject
            render :json => @comment.to_json
          }
        end
      else
        ## Very important let empty => mean any comment exist for javascript
        render :json => ""
      end
    elsif params[:webapp_id]
      if  @webapp = Webapp.find(params[:webapp_id])
        @comments = @webapp.comments.commented
        render :layout => false
      else
        flash[:error] = "La Webapp demandé n'existe pas"
        redirect_to accueil_path
      end
    else
      flash[:error] = "La page demandée n'existe pas"
      redirect_to accueil_path
    end
    
  end


  def create
    if(params[:webapp_id])
      @webapp = Webapp.find_by_id(params[:webapp_id])
      @comment  = current_user.comments.build(:rating => params[:rating], :body => params[:comment])
      @comment.webapp_id = @webapp.id
      if @comment.save
        flash[:success] = "Commentaire ajouté"
        @comments = @webapp.comments.commented
        render "index", :layout => false 
      else
        flash[:error] = "Vous avez déjà commenté pour ce website"
        redirect_to accueil_path
      end
    else
      flash[:error] = "La page demandée n'existe pas"
      redirect_to accueil_path
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @webapp = Webapp.find_by_id(@comment.webapp_id)
      if @comment.update_attributes(:body =>params[:comment], :rating => params[:rating])
        @comments = @webapp.comments.commented
        render "index", :layout => false 
      else
        flash[:error] = "Impossible d'éditer correctement ce commentaire"
        redirect_to accueil_path
      end
    else
      flash[:error] = "Le commentaire à édité n'existe pas"
      redirect_to accueil_path
    end
  end

    # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to user_path current_user }
    end
  end
end
