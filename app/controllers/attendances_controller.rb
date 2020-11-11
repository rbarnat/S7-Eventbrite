class AttendancesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @attendances = Attendance.find_by(event_id: params[:event_id])
  end

  def show
    @attendance = Attendance.find(params[:id])
  end

  def new
    @attendance = Attendance.new( user_id: current_user.id,
                                  event_id: params[:event_id])
  end

  def create
    @event = Event.find(params[:event_id])
    
    # STRIPE section 1
    if !is_event_free?
      # Amount in cents
      @amount = @event.price * 100
        
      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })

      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: "EvenTually: inscription event",
        currency: 'eur'
      })

      @attendance = Attendance.new( user_id: current_user.id,
        event_id: @event.id,
        stripe_customer_id: customer.id )
    else
      @attendance = Attendance.new( user_id: current_user.id,
        event_id: @event.id,
        stripe_customer_id: nil )
    end

    

    if @attendance.save # essaie de sauvegarder en base
      # si ça marche, il redirige vers la page d'index du site
      puts "Vous participez désormais à l'événement."
      flash[:success] = "Vous participez désormais à l'événement."
      redirect_to event_path(params[:event_id])
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      puts "La participation à l'événement a échoué."
      flash.now[:error] = "La participation à l'événement a échoué."
      flash.now[:error] = @attendance.errors.full_messages.to_sentence
      render :new
    end

    # STRIPE section 2
    rescue Stripe::CardError => e
      puts "e.message : #{e.message}"
      flash[:error] = e.message
      redirect_to new_event_attendances_path
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    
    if @attendance.update(post_params)
      flash[:success] = "La participation à l'événement a bien été mise à jour."
      redirect_to event_path
    else
      flash.now[:error] = "La participation à l'événement a échoué."
      flash.now[:error] = @attendance.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    if @attendance.destroy
      flash[:success] = "La participation à l'événement a bien été supprimée."
      redirect_to events_path
    else
      flash[:error] = "La participation à l'événement n'a pas été supprimée."
      flash[:error] = @attendance.errors.full_messages.to_sentence
      redirect_to event_path
    end
  end

  def post_params
    param.require(:attendance).permit()
  end

  def is_event_free?
    @event = Event.find(params[:event_id])
    return @event.price == 0
  end
end
