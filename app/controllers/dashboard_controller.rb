class DashboardController < ApplicationController
  def index
    return unless user_signed_in?

    @map_locations = current_user.locations.with_coordinates.order(:name)
  end
end
