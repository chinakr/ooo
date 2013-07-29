class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize
  protected
    def authorize
      begin
        @user = User.find(session[:user_id])
        @admin = Group.find_by_code_name('admin')
        unless @user.groups.include?(@admin)
          session[:user_id] = nil
          redirect_to login_url, alert: t('messages.permission_denied')
        end
      rescue
        redirect_to login_url, alert: t('messages.permission_denied')
      end
    end
end
