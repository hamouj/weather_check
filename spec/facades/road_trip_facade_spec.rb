require 'rails_helper'

describe RoadTripFacade do
  describe 'instance methods' do
    before(:each) do
      @facade = RoadTripFacade.new({ origin: 'las vegas,nv', destination: 'denver,co' })
    end

    context '#initialize' do
      it 'exists' do
        expect(@facade).to be_a(RoadTripFacade)
      end
    end

    context '#complete_road_trip' do
      it 'creates a RoadTrip object with attributes' do
        VCR.use_cassette('lv_to_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          VCR.use_cassette('roadtrip_weather', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
            expect(@facade.complete_road_trip).to be_a(RoadTrip)
            expect(@facade.complete_road_trip.start_city).to eq('las vegas,nv')
            expect(@facade.complete_road_trip.end_city).to eq('denver,co')
            expect(@facade.complete_road_trip.travel_time).to eq('10h32m')
            expect(@facade.complete_road_trip.weather_at_eta).to be_an(ArrivalWeather)
            expect(@facade.complete_road_trip.weather_at_eta.datetime).to eq('2023-04-25 04:00')
            expect(@facade.complete_road_trip.weather_at_eta.temperature).to eq(46.6)
            expect(@facade.complete_road_trip.weather_at_eta.condition).to eq('Thundery outbreaks possible')
          end
        end
      end

      it 'creates a RoadTrip object with an impossible travel time and empty weather_at_eta attribute' do
        @facade2 = RoadTripFacade.new({ origin: 'new york,ny', destination: 'london,uk' })

        VCR.use_cassette('ny_to_uk', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          expect(@facade2.complete_road_trip).to be_a(RoadTrip)
          expect(@facade2.complete_road_trip.start_city).to eq('new york,ny')
          expect(@facade2.complete_road_trip.end_city).to eq('london,uk')
          expect(@facade2.complete_road_trip.travel_time).to eq('impossible')
          expect(@facade2.complete_road_trip.weather_at_eta).to eq({})
        end
      end
    end
  end
end
