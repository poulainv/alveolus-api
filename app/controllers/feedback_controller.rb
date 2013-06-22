# encoding: utf-8
class FeedbackController < BaseController
  layout false

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:comment],params[:page])
    if user_signed_in?
      @feedback.email = current_user.email 
    else
      @feedback.email = params[:email]
    end
    
    if @feedback.valid?
      FeedbackMailer.feedback(@feedback).deliver
      
      render :json =>  {:success => '<h4>Bien reçu, merci ! '+@feedback.comment+'</h4>'}, :status => :created
    else
      @error_message = "Please enter your #{@feedback.subject.to_s.downcase}"

	  # Returns the whole form back. This is not the most effective
      # use of AJAX as we could return the error message in JSON, but
      # it makes easier the customization of the form with error messages
      # without worrying about the javascript.
      render :json => {:errors => @error_message}, :status => :unprocessable_entity
    end
  end
end
