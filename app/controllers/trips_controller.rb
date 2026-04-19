class TripsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_trip, only: %i[ show edit destroy ]

  # GET /trips or /trips.json
  def index
    @trips = Trip.includes(:location, :fishes).order(created_at: :desc)
  end

  # GET /trips/1 or /trips/1.json
  def show
  end

  # GET /trips/new — step 1: location | step 2: trip name (params) | step 3 uses wizard_fish
  def new
    case params[:step].to_s
    when "2"
      setup_wizard_trip_name_step or return
    else
      @location = current_user.locations.build
      @trip = Trip.new
      @wizard_step = :location
    end
  end

  # POST /trips/wizard_location — step 1: save location → step 2
  def wizard_location
    @location = current_user.locations.build(location_wizard_params)
    if @location.save
      redirect_to new_trip_path(location_id: @location.id, step: 2), notice: t("trips.wizard.location_saved")
    else
      @trip = Trip.new
      @wizard_step = :location
      render :new, status: :unprocessable_entity
    end
  end

  # POST /trips/wizard_trip_name — step 2: create trip (name + location only) → step 3
  def wizard_trip_name
    @trip = Trip.new(wizard_trip_name_params)
    @trip.user = current_user
    if @trip.save
      redirect_to wizard_fish_trip_path(@trip)
    else
      @location = current_user.locations.find_by(id: @trip.location_id)
      @wizard_step = :trip_name
      render :new, status: :unprocessable_entity
    end
  end

  # GET /trips/:id/wizard_fish — step 3: add fish
  def wizard_fish
    @trip = current_user.trips.includes(:location, :fishes).find(params[:id])
    @location = @trip.location
    @wizard_step = :fish
    @trip.fishes.build if @trip.fishes.empty?
    render :new
  end

  # GET /trips/1/edit
  def edit
    @locations = current_user.locations.order(:name)
  end

  # POST /trips — JSON / legacy (HTML wizard uses wizard_trip_name)
  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: t("trips.wizard.trip_created") }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { redirect_to new_trip_path, alert: t("trips.wizard.create_failed") }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1 — includes wizard fish step when trip[wizard_fish]=1
  def update
    if params.dig(:trip, :wizard_fish).present?
      update_wizard_fish
      return
    end

    set_trip
    @locations = current_user.locations.order(:name)

    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: "Trip was successfully updated." }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1 or /trips/1.json
  def destroy
    @trip.destroy!

    respond_to do |format|
      format.html { redirect_to trips_path, status: :see_other, notice: "Trip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def setup_wizard_trip_name_step
    unless params[:location_id].present?
      redirect_to new_trip_path
      return false
    end

    @location = current_user.locations.find_by(id: params[:location_id])
    unless @location
      redirect_to new_trip_path, alert: t("trips.wizard.unknown_location")
      return false
    end

    @trip = Trip.new(location_id: @location.id)
    @wizard_step = :trip_name
    true
  end

  def update_wizard_fish
    @trip = current_user.trips.includes(:location, :fishes).find(params[:id])
    @location = @trip.location

    if @trip.update(fishes_only_params)
      redirect_to @trip, notice: t("trips.wizard.trip_created")
    else
      @wizard_step = :fish
      @trip.fishes.build if @trip.fishes.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def set_trip
    @trip = Trip.includes(:location, :fishes).find(params[:id])
  end

  def location_wizard_params
    params.require(:location).permit(:name, :latitude, :longitude, :accessibility, :conditions, :proximity)
  end

  def wizard_trip_name_params
    p = params.require(:trip).permit(:name, :location_id)
    scrub_location_access!(p)
    p
  end

  def fishes_only_params
    params.require(:trip).permit(fishes_attributes: %i[id name quantity kind weight _destroy])
  end

  def trip_params
    p = params.require(:trip).permit(
      :name,
      :location_id,
      location_attributes: %i[id name latitude longitude accessibility conditions proximity],
      fishes_attributes: %i[id name quantity kind weight _destroy]
    )
    scrub_location_access!(p)
    p
  end

  def scrub_location_access!(permitted)
    if permitted[:location_id].present? && !current_user.locations.exists?(id: permitted[:location_id])
      permitted[:location_id] = nil
    end

    la = permitted[:location_attributes]
    return unless la && la[:id].present?

    la.delete(:id) unless current_user.locations.exists?(id: la[:id])
  end
end
