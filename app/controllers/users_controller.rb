class UsersController < ApplicationController
  before_filter :set_user, only: [ :show, :edit, :update, :destroy, :following, :followers ]
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,  only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to my micro twitter!"
      redirect_to @user
    else
      render 'new'
    end

  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  #/user/following/1
  def following
    @title = 'Following'
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Before filters
    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end