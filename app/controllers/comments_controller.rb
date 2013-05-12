# encoding: utf-8


class CommentsController < ApplicationController

  before_filter :authenticate_user! , :only => [:create, :update, :destroy]

  def index
    # GET Comment for user/webapp/
    if params[:webapp_id] and params[:user_id]
     @comment = Comment.find_by_webapp_id_and_user_id(params[:webapp_id], params[:user_id])

   elsif params[:user_id]
     @comment = Comment.find_by_user_id(params[:user_id])

    # GET Comment for webapp/
  elsif params[:webapp_id]
    if  @webapp = Webapp.find(params[:webapp_id])
      @comments = @webapp.comments.commented
    else render "webapp not found", :status => :not_found    
    end
  end
  render json: @comments.to_json

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
