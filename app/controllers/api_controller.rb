class ApiController < ApplicationController
  skip_before_filter :authorize, :verify_authenticity_token
  def initialize
    @secret_key = 'HelloWorld_123456'
  end
  def login
    if @secret_key == params[:secret_key] and user = User.authenticate(params[:username], params[:password])
      @status = 'ok'
    else
      @status = 'error'
    end
    respond_to do |format|
      format.json
    end
  end

  def member
    if @secret_key == params[:secret_key]
      @user = User.find_by_username(params[:username])
      @group = Group.find_by_code_name(params[:group_codename])
      if @user.groups.include?(@group)
        @status = 'true'
      else
        @status = 'false'
      end
    else
      #@status = @secret_key + params[:secret_key]
      @status = 'forbidden'
    end
    respond_to do |format|
      format.json
    end
  end
end
