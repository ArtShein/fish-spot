class ProfilesController < ApplicationController
  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    debugger
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @location, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, profile: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone, :description, :avatar)
  end
end
