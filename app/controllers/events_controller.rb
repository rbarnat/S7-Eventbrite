class EventsController < ApplicationController
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
                        event_admin_id: params[:event_admin_id])

    if @event.save # essaie de sauvegarder en base @event
      # si ça marche, il redirige vers la page d'index du site
      flash[:success] = "L'event a bien été créé."
      redirect_to events_path
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
    @event.update(post_params)
    redirect_to event_path
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def post_params
    param.require(:event).permit(:start_date, :duration, :title, :description, :price, :location, :event_admin_id)
  end
end
