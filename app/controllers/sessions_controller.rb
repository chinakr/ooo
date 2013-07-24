class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to users_path
    else
      redirect_to login_path, alert: t('.mismatch_login')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, alert: t('.already_logout')
  end
end
