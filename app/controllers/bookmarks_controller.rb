# encoding: utf-8


class BookmarksController < ApplicationController


 # GET "webapps/:webapp_id/bookmarks
  def index
    
    @bookmarks = current_user.webapps_starred

  end

 # POST "webapps/:webapp_id/bookmarks
  def create
    @bookmark  = current_user.bookmarks.build(:webapp_id => params[:webapp_id])
    @bookmark.user_id = current_user.id
     if @bookmark.save
        flash[:success] = "Favoris ajouté"
        render :json => "ok".to_json
      else
        flash[:error] = "Vous avez déjà ajouté ce website"
        redirect_to accueil_path
      end
  end

  def update

  end

  def destroy
    @bookmark = Bookmark.find_by_user_id_and_webapp_id(current_user.id, params[:webapp_id])
    @bookmark.destroy
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end
