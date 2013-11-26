class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end


  def create
    event = params
    event_id = event[:id]
    @event = Event.create_from_stripe_id(event_id)

    respond_to do |format|
      if @event.save
        format.json { render json: @event, status: :ok, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
end
