# frozen_string_literal: true

# app/facades/roadtrip_facade.rb
class RoadtripFacade
  def initialize(params)
    @origin = params[:origin]
    @destination = params[:destination]
  end

  def find_lat_lng
    data = MapquestService.get_lat_lng(@destination)
    location_data = data[:results][0][:locations][0][:latLng]
    Location.new(location_data)
  end

  def make_roadtrip
    data = MapquestService.get_route(@origin, @destination)
    @roadtrip ||= Roadtrip.new(@origin, @destination, data)
  end

  def add_arrival_weather
    data = WeatherService.get_arrival_weather(find_lat_lng.lat_lng, formatted_arrival_date, arrival_time.hour)
    arrival_data = data[:forecast][:forecastday][0][:hour][0]
    @roadtrip.weather_at_eta = ArrivalWeather.new(arrival_data)
  end

  def complete_roadtrip
    make_roadtrip
    add_arrival_weather
    @roadtrip
  end 

  private
    def arrival_time
      # if @roadtrip.travel_time.include?('d')
      #   date =  DateTime.now + (@roadtrip.travel_time.partition('d').first.to_i)
      #   date + (@roadtrip.travel_time.gsub(/.*[d]/,"").partition('h').first.to_i).hour 
      # elsif @roadtrip.travel_time.include?('h')
      #   DateTime.now + (@roadtrip.travel_time.gsub(/.*[d]/,"").partition('h').first.to_i).hour 
      # else
      #   DateTime.now + 1
      # end
      DateTime.now + (@roadtrip.time.partition(':').first.to_i).hour
    end

    def formatted_arrival_date
      arrival_time.strftime("%Y-%m-%d")
    end
end
