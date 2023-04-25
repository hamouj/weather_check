require 'rails_helper'

describe RoadtripFacade do
  describe 'instance methods' do
    before(:each) do
      @facade = RoadtripFacade.new({origin: 'las vegas,nv', destination: 'denver,co'})
    end

    context '#initialize' do
      it 'exists' do
        expect(@facade).to be_a(RoadtripFacade)
      end
    end

    context '#complete_roadtrip' do
      it 'creates a Roadtrip object with attributes' do
        VCR.use_cassette('lv_to_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          VCR.use_cassette('roadtrip_weather', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
            expect(@facade.complete_roadtrip).to be_a(Roadtrip)
            expect(@facade.complete_roadtrip.start_city).to eq('las vegas,nv')
            expect(@facade.complete_roadtrip.end_city).to eq('denver,co')
            expect(@facade.complete_roadtrip.travel_time).to eq('10h32m')
            expect(@facade.complete_roadtrip.weather_at_eta).to be_an(ArrivalWeather)
            expect(@facade.complete_roadtrip.weather_at_eta.datetime).to eq('2023-04-25 04:00')
            expect(@facade.complete_roadtrip.weather_at_eta.temperature).to eq(46.6)
            expect(@facade.complete_roadtrip.weather_at_eta.condition).to eq('Thundery outbreaks possible')
          end
        end
      end

      it 'creates a Roadtrip object with an impossible travel time and empty weather_at_eta attribute' do
        @facade2 = RoadtripFacade.new({origin: 'new york,ny', destination: 'london,uk'})
        
        VCR.use_cassette('ny_to_uk', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          expect(@facade2.complete_roadtrip).to be_a(Roadtrip)
          expect(@facade2.complete_roadtrip.start_city).to eq('new york,ny')
          expect(@facade2.complete_roadtrip.end_city).to eq('london,uk')
          expect(@facade2.complete_roadtrip.travel_time).to eq('impossible')
          expect(@facade2.complete_roadtrip.weather_at_eta).to eq({})
        end
      end
    end
  end
end