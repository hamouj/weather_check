# frozen_string_literal: true

# app/poros/arrival_weather.rb
class ArrivalWeather
  attr_reader :datetime,
              :temperature,
              :condition
  
  def initialize(data)
    @datetime = data[:time]
    @temperature = data[:temp_f]
    @condition = data[:condition][:text]
  end
end