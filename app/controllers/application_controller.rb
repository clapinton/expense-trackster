class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login(user)
    # Set the session token to the session cookie
    session[:session_token] = user.session_token
  end

  def logout
    current_user.reset_session_token
    session[:session_token] = nil
  end

  def require_signed_in
    unless current_user
      render json: ["You need to log in first"], status: 403
    end
  end

  def require_correct_owner
    if current_user.id.to_s != expense_params[:owner_id]
      render json: ["You do not have permission to execute this action."], status: 403
    end    
  end

  def require_owner_or_admin
    if current_user.id.to_s != expense_params[:owner_id] || !current_user.is_admin
      render json: ["You do not have permission to execute this action."], status: 403
    end
  end

end
