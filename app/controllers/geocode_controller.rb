require "net/http"
require "uri"
require "json"

class GeocodeController < ApplicationController
  # Reverse geocode (Nominatim). Used to suggest a location name from coordinates.
  before_action :authenticate_user!

  def reverse
    lat = params[:lat].to_f
    lng = params[:lng].to_f

    unless lat.finite? && lng.finite? && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180
      return render json: { error: "invalid coordinates" }, status: :unprocessable_entity
    end

    uri = URI("https://nominatim.openstreetmap.org/reverse")
    uri.query = URI.encode_www_form(
      format: "jsonv2",
      lat: format("%.6f", lat),
      lon: format("%.6f", lng),
      "accept-language": I18n.locale.to_s
    )

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 3
    http.read_timeout = 3

    req = Net::HTTP::Get.new(uri)
    req["User-Agent"] = "FishSpot/1.0 (https://github.com/)"

    res = http.request(req)
    unless res.is_a?(Net::HTTPSuccess)
      return render json: { error: "geocoder unavailable" }, status: :bad_gateway
    end

    data = JSON.parse(res.body)
    name = short_place_name(data)
    render json: { name: name, display_name: data["display_name"] }
  rescue JSON::ParserError, Net::OpenTimeout, Net::ReadTimeout, SocketError
    render json: { error: "geocoder error" }, status: :bad_gateway
  end

  private

  def short_place_name(data)
    addr = data["address"]
    return data["display_name"].to_s.split(",").first&.strip if addr.blank?

    %w[hamlet village town city municipality county state].each do |key|
      next unless addr[key].present?

      return addr[key].to_s
    end

    data["display_name"].to_s.split(",").first&.strip || "—"
  end
end
