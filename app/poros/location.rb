# frozen_string_literal: true

# app/poros/location.rb
class Location
  attr_reader :lat_lng

  def initialize(data)
    @lat_lng = "#{data[:lat]},#{data[:lng]}"
  end
end
