require 'rails_helper'

describe ForecastFacade do
  describe 'instance methods' do
    before(:each) do
      @facade = ForecastFacade.new('lasvegas,nv')
    end

    context '#initialize' do
      it 'exists' do
        expect(@facade).to be_a(ForecastFacade)
      end
    end

    context '#find_lat_lng' do
      it 'creates a Location object' do
        VCR.use_cassette('lat_lng_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
          expect(@facade.find_lat_lng).to be_a(Location)
        end
      end
    end

    context '#fetch_forecast' do
      it 'creates a Forecast object' do
        VCR.use_cassette('weather_forecast_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
          VCR.use_cassette('lat_lng_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
            expect(@facade.fetch_forecast).to be_a(Forecast)
          end
        end
      end
    end
  end
end
