class Api::UsersController < ApplicationController

  before_action :require_signed_in!, only: [:show]

  def create

    @user = User.new(user_params)

    if @user.save
      # If new user if valid, login (session cookie = session_token)
      login(@user)
      render "api/users/show"
    else
      errors = @user.errors.full_messages
      if errors.any? {|err| err.include?("already been taken")}
        status_code = 401 #UNAUTHORIZED
      else
        status_code = 422 #UNPROCESSABLE ENTITY
      end
      render json: @user.errors.full_messages, status: status_code
    end
  end  

  def show
    @user = User.find(params[:id])
    if current_user.id === @user.id
      render "api/users/show"
    else
      render json:"You do not have permission to view this user."
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :is_admin)
  end

end
