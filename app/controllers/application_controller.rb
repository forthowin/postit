class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :same_user?

  def logged_in?
    !!current_user
  end

  def current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !logged_in?
      respond_to do |format|
        format.html do
          flash[:error] = "You must be logged in to do that"
          redirect_to root_path
        end
        format.js
      end
    end
  end

  def same_user?(obj)
    current_user == obj.creator
  end

  def to_boolean(str)
    str == 'true'
  end
end
