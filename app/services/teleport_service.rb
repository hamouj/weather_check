# frozen_string_literal: true

# app/services/teleport_service.rb
class TeleportService
  def self.get_salaries(destination)
    get_url("api/urban_areas/slug:#{destination}/salaries/")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.teleport.org/')
  end
end