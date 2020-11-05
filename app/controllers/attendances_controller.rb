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
    @event = Event.find(params[:event_id])
    
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

    puts "customer: customer.id : #{customer.id}"
    puts "amount: @amount : #{@amount}"

    @attendance = Attendance.new( user_id: current_user.id,
                                  event_id: @event.id,
                                  stripe_customer_id: customer.id)

    puts "@attendance.user_id :#{@attendance.user_id}"
    puts "@attendance.event_id :#{@attendance.event_id}"
    puts "@attendance.stripe_customer_id :#{@attendance.stripe_customer_id}"

    if @attendance.save # essaie de sauvegarder en base
    # si ça marche, il redirige vers la page d'index du site
    puts "Vous participez désormais à l'événement."
    flash[:success] = "Vous participez désormais à l'événement."
    redirect_to event_path(params[:event_id])
    else
    # sinon, il render la view new (qui est celle sur laquelle on est déjà)
    puts "La participation à l'événement a échoué."
    flash.now[:danger] = "La participation à l'événement a échoué."
    render :new
    end

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
