class AttendancesController < ApplicationController
  def index
    @attendance = Attendance.all
  end

  def show
    @attendance = Attendance.find(params[:id])
  end

  def new
    @attendance = Attendance.new( user_id: current_user.id,
                                  event_id: params[:event_id])
  end

  def create
    @attendance = Attendance.new( user_id: current_user.id,
                                  event_id: params[:event_id],
                                  stripe_customer_id: params[:stripe_customer_id])

    if @attendance.save # essaie de sauvegarder en base
    # si ça marche, il redirige vers la page d'index du site
    flash[:success] = "Vous participez désormais à l'événement."
    redirect_to event_path(params[:event_id])
    else
    # sinon, il render la view new (qui est celle sur laquelle on est déjà)
    flash.now[:danger] = "La participation à l'événement a échoué."
    render :new
    end
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.update(post_params)
    redirect_to event_path
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy
    redirect_to events_path
  end

  def post_params
    param.require(:attendance).permit()
  end
end
