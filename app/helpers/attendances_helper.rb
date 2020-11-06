module AttendancesHelper
  def is_event_free?
    @event = Event.find(params[:event_id])
    return @event.price == 0
  end
end
