class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :add_to_group]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)
    #@users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    if User.count > 0 and session[:user_id] == nil
      redirect_to login_url, alert: t('messages.permission_denied')
    end
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        if User.count == 1    # the first user should be administrator
          @admin = Group.find_by_code_name('admin')
          @admin.users << @user
        end
        format.html { redirect_to @user, notice: t('.user_created') }
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.id == session[:user_id]
      redirect_to users_path, alert: t('.cannot_delete_current_user')
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/1/add-to-group
  # POST /users/1/add-to-group/1
  def add_to_group
    @groups = Group.order('name')
    @filter = 'all'
    if request.method == 'GET'
      if params[:filter] == 'active'
        @groups = @user.groups.order('name')
        @filter = 'active'
      elsif params[:filter] == 'inactive'
        groups = []
        @groups.each do |g|
          groups << g unless @user.groups.include?(g)
        end
        @groups = groups
        @filter = 'inactive'
      end
    end
    if request.method == 'POST'
      @group = Group.find(params[:group_id])
      if params[:func] == 'add'
        @user.groups << @group
      elsif params[:func] == 'remove'
        @user.groups.delete(@group)
      end
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :name, :email, :mobile, :is_staff, :note)
      #params.require(:user).permit(:username, :hashed_password, :salt, :name, :email, :mobile, :is_staff, :note)
    end
end
