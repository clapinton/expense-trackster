class Api::SessionsController < ApplicationController

  def create
    @user = User.find_by_credentials(
    user_params[:email], user_params[:password]
    )
    if @user
      login(@user)
      render "api/users/show"
    else
      #The FE's reducer expects an array of error messages
      render json: ["Oops, wrong credentials."], status: 404
    end

  end

  def destroy
    if current_user
      logout
      render json: {}
    else
      #The FE's reducer expects an array of error messages
      render json: ["No user currently logged in."], status: 404
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
