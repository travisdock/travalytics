class ExternalEventsController < ApplicationController
  before_action :require_authentication
  before_action :set_external_event, only: [ :edit, :update, :destroy ]

  def index
    @external_events = current_user.external_events.recent
  end

  def new
    @external_event = current_user.external_events.build
  end

  def create
    @external_event = current_user.external_events.build(external_event_params)

    if @external_event.save
      redirect_to external_events_path, notice: "External event created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @external_event.update(external_event_params)
      redirect_to external_events_path, notice: "External event updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @external_event.destroy
    redirect_to external_events_path, notice: "External event deleted successfully"
  end

  private

  def set_external_event
    @external_event = current_user.external_events.find(params[:id])
  end

  def external_event_params
    params.require(:external_event).permit(:event_type, :title, :description, :event_date, :url, :metadata)
  end
end
