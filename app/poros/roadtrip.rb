# frozen_string_literal: true

# app/poros/roadtrip.rb
class Roadtrip
  attr_reader :start_city,
              :end_city,
              :travel_time
  
  def initialize(params, route_data)
    @start_city = params[:origin]
    @end_city = params[:destination]
    @travel_time = (route_data[:route][:formattedTime]).to_datetime.strftime("%Hh%Mm")
  end
end