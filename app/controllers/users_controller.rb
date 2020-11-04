class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @events = Event.find_by(event_admin_id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( email: params[:email], 
                      password: params[:password],
                      password_confirmation: params[:password_confirmation], 
                      description: params[:description], 
                      first_name: params[:first_name], 
                      last_name: params[:last_name])

    if @user.save # essaie de sauvegarder en base @user
      # si ça marche, il redirige vers la page d'index du site
      flash[:success] = "L'utilisateur a bien été créé."
      redirect_to users_path
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      flash.now[:danger] = "L'utilisateur n'a pas été créé."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(post_params)
    redirect_to user_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  def post_params
    param.require(:user).permit(:email, :password, :password_confirmation, :description, :first_name, :last_name)
  end
end
