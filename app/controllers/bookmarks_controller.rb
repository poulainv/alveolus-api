# encoding: utf-8


class BookmarksController < BaseController


 # GET "webapps/:webapp_id/bookmarks OR /users/:user_id/bookmarks
  def index
    if (params[:webapp_id])
      @bookmarks = Webapp.find(params[:webapp_id]).bookmarks
    elsif (params[:user_id])
      @bookmarks = Webapp.find(params[:user_id]).bookmarks
    end
    render json: @bookmarks
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
