class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy]
  before_action :redirect_if_user_not_current_user

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
      flash.now[:error] = "L'utilisateur n'a pas été créé."
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(description: params[:description], 
                    first_name: params[:first_name], 
                    last_name: params[:last_name])
      flash[:success] = "L'utilisateur a bien été modifié."
      redirect_to @user
    else
      flash.now[:error] = "L'utilisateur n'a pas été modifié."
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "L'utilisateur a bien été supprimé."
      redirect_to root_path
    else
      flash[:error] = "L'utilisateur n'a pas été supprimé."
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  def is_user_current_user?
    @user = User.find(params[:id])
    return user_signed_in? && @user.id == current_user.id
  end

  def redirect_if_user_not_current_user
    if !is_user_current_user?
      flash[:danger] = "Vous n'avez pas l'autisation de gérer ce profil."
      redirect_to root_path
    end
  end

  private

  def post_params
    param.require(:user).permit(:email, :password, :password_confirmation, :description, :first_name, :last_name)
  end

  
end
