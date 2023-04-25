# frozen_string_literal: true

# app/facades/road_trip_facade.rb
class RoadTripFacade
  def initialize(params)
    @origin = params[:origin]
    @destination = params[:destination]
  end

  def find_lat_lng
    data = MapquestService.get_lat_lng(@destination)
    location_data = data[:results][0][:locations][0][:latLng]
    Location.new(location_data)
  end

  def make_road_trip
    data = MapquestService.get_route(@origin, @destination)
    @road_trip ||= if data[:route].key?(:routeError)
                     RoadTrip.new(@origin, @destination, nil)
                   else
                     RoadTrip.new(@origin, @destination, data)
                   end
  end

  def add_arrival_weather
    data = WeatherService.get_arrival_weather(find_lat_lng.lat_lng, formatted_arrival_date, arrival_time.hour)
    arrival_data = data[:forecast][:forecastday][0][:hour][0]
    @road_trip.weather_at_eta = ArrivalWeather.new(arrival_data)
  end

  def complete_road_trip
    make_road_trip
    if @road_trip.travel_time != "impossible"
      add_arrival_weather
    end
    @road_trip
  end

  private

  def arrival_time
    DateTime.now + @road_trip.time.partition(':').first.to_i.hour
  end

  def formatted_arrival_date
    arrival_time.strftime("%Y-%m-%d")
  end
end
