class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :redirect_if_user_not_event_admin, only: [:edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new()
  end

  def create
    @event = Event.new( start_date: params[:start_date],
                        duration: params[:duration],
                        title: params[:title],
                        description: params[:description],
                        price: params[:price],
                        location: params[:location],
                        event_admin_id: current_user.id)

    if @event.save # essaie de sauvegarder en base @event
      # si ça marche, il redirige vers la page d'index du site
      flash[:success] = "L'event a bien été créé."
      redirect_to @event
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      flash.now[:danger] = "L'event n'a pas été créé."
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(post_params)
      flash[:success] = "L'event a bien été modifié."
      redirect_to @event
    else
      flash[:danger] = "L'event n'a pas été modifié."
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def redirect_if_user_not_event_admin
    @event = Event.find(params[:id])
    if !(user_signed_in? && @event.event_admin.id == current_user.id)
      flash[:danger] = "Vous n'avez pas l'autisation de gérer cet event."
      redirect_to event_path
    end
  end

  def post_params
    params.require(:event).permit(:start_date, :duration, :title, :description, :price, :location)
  end
end
