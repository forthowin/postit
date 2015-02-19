class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:username])

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You have successfully log in"
      redirect_to root_path
    else
      flash.now[:error] = "Wrong username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out"
    redirect_to root_path
  end
end