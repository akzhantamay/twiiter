class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:edit, :update, :destroy, :following, :followers]
  before_action :check_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
 
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end
 
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      sign_in @user
      flash[:success]= "Добро пожаловать, #{@user.name} !"
      redirect_back_or(@user)
    else
      render "new"
    end
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Обновление прошло успешно"
      redirect_to @user
    else 
      render "edit"
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if user
      user.destroy 
      flash[:success] = "Пользователь удален"
      redirect_to root_url
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        flash[:danger] = "Требуется авторизация"
        redirect_to signin_url
      end
    end
    
    def check_user
      user = User.find(params[:id])
      unless current_user.id == user.id
        flash[:danger] = "Вы не авторизованы"
        redirect_to root_url
      end
    end
    
    def admin_user
      unless current_user.admin?
      flash[:danger] = "Вы не админ!"
      redirect_to root_url 
      end
    end
  
end
