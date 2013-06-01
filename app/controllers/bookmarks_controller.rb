# encoding: utf-8
class BookmarksController < BaseController

  before_filter :user_needed!, :only => [:create]
  
 # GET "webapps/:webapp_id/bookmarks OR /users/:user_id/bookmarks
  def index
    if params[:webapp_id] && params[:user_id]
      @bookmark = Bookmark.find_by_webapp_id_and_user_id(params[:webapp_id], params[:user_id])
      render json: @bookmark
      return
    elsif (params[:webapp_id])
      @bookmarks = Webapp.find(params[:webapp_id]).bookmarks
    elsif (params[:user_id])
      @bookmarks = User.find(params[:user_id]).bookmarks
    end
    render json: @bookmarks
  end

 # POST "webapps/:webapp_id/bookmarks
  def create
    @bookmark  = current_user.bookmarks.build(:webapp_id => params[:webapp_id])
    @bookmark.user_id = current_user.id
     if @bookmark.save
        render :json => {:success => "Alveolus bookmarked"}, :status => :created
      else
        render :json => {:errors => @bookmark.errors.full_messages } ,:status => :unprocessable_entity
      end
  end

  def update

  end

  def destroy
    @bookmark = Bookmark.find_by_user_id_and_webapp_id(current_user.id, params[:webapp_id])
    @bookmark.destroy    
    render :json => {:success => "Alveolus debookmarked"}, :status => :created
  end
end
