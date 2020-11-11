class AdminsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :redirect_if_user_not_admin, only: [:index]
  
  def index
    @admin = current_user
    @events = Event.all
    @users = User.all
    @attendances = Attendance.all
  end

  def redirect_if_user_not_admin
    if !(user_is_admin?)
      flash[:danger] = "Vous n'avez pas l'autisation de gérer l'administration."
      redirect_to root_path
    end
  end

  def user_is_admin?
    return (user_signed_in? && current_user.is_admin)
  end
end
