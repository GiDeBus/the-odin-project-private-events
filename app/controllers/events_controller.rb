class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      flash[:success] = "Your event was saved."
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.creator_id == current_user.id
      if @event.update(event_params)
        flash[:success] = "#{@event.name} was edited."
        redirect_to @event
      else
        render 'edit', status: :unprocessable_entity
      end
    else
      flash[:notice] = "Only hosts can edit this event."
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.creator_id == current_user.id
      @event.destroy
      flash[:success] = "#{@event.name} was deleted."
      redirect_to root_path
    else
      flash[:notice] = "Only hosts can edit this event."
      redirect_to @event
    end
  end

  private
  
  def event_params
    params.require(:event).permit(:name, :date, :description, :location)
  end
end
