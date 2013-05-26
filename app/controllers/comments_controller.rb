# encoding: utf-8


class CommentsController < BaseController

  before_filter :user_needed! , :only => [:create, :update, :destroy]

def index
    # GET Comment for user/webapp/
  if params[:webapp_id] and params[:user_id]
     @comment = Comment.find_by_webapp_id_and_user_id(params[:webapp_id], params[:user_id])
     render "comments/show"
  elsif params[:user_id]
     @comment = Comment.find_by_user_id(params[:user_id])
     render "comments/show"
    # GET Comment for webapp/
  elsif params[:webapp_id]
    if  @webapp = Webapp.find(params[:webapp_id])
      @comments = @webapp.comments.commented
      render "comments/index"
    else
      render :json => {:errors => "I can't find this aveolus or maybe user, contact admin ;)"}, :status => :not_found
      return 
    end
  end
end

def create
  if(params[:webapp_id])
    @webapp = Webapp.find_by_id(params[:webapp_id])
    @comment  = current_user.comments.build(:rating => params[:rating], :body => params[:comment])
    @comment.webapp_id = @webapp.id
    if @comment.save
      @comments = @webapp.comments.commented
      render "comments/index"
    else
      render :json => {:errors => @comment.errors.full_messages}, :status => :unprocessable_entity
    end
  else
   render :json => {:errors => "I need webapp_id dude"}, :status => :unprocessable_entity
 end
end

def update
  @comment = Comment.find(params[:id])
  if @webapp = Webapp.find_by_id(@comment.webapp_id)
    if @comment.update_attributes(:body =>params[:comment], :rating => params[:rating])
      @comments = @webapp.comments.commented
      render "comments/index"
    else
      render :json => {:errors => @comment.errors.full_messages}, :status => :unprocessable_entity
    end
  else
   render :json => {:errors => "I can't find this aveolus"}, :status => :not_found
 end
end

    # DELETE /comments/1
    def destroy
      @comment = Comment.find(params[:id])
      if current_user.id == @comment.user.id
        @webapp = @comment.webapp
        @comment.destroy
        @comments = @webapp.comments.commented
        render "comments/index"
      else
       render :json => {:errors => "You can delete just your comment"}, :status => :unprocessable_entity
       end
    end
  end
