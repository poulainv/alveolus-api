class ConfirmationsController < Devise::ConfirmationsController
def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
        render "confirmations/show"
    else
      render json: "Echec, token incorrect"
    end
end

end