# frozen_string_literal: true

# app/poros/road_trip.rb
class RoadTrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :time

  attr_accessor :weather_at_eta

  def initialize(origin, destination, route_data)
    @id = nil
    @start_city = origin
    @end_city = destination
    if route_data.nil?
      @travel_time = "impossible"
      @weather_at_eta = {}
    else
      @travel_time = format_travel_time(route_data[:route][:time])
      @time = route_data[:route][:formattedTime]
      @weather_at_eta = nil
    end
  end

  def format_travel_time(time)
    minutes_seconds = time.divmod(60)
    hours_minutes = minutes_seconds.first.divmod(60)
    day_hours = hours_minutes.first.divmod(24)

    if day_hours.first == 0
      "#{hours_minutes.first}h#{hours_minutes.second}m"
    else
      "#{day_hours.first}d#{day_hours.second}h#{hours_minutes.second}m"
    end
  end
end
