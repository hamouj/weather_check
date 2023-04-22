require 'rails_helper'

describe MapquestFacade do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        mapquest_facade = MapquestFacade.new('lasvegas,nv')

        expect(mapquest_facade).to be_a(MapquestFacade)
        expect(mapquest_facade.location).to eq('lasvegas,nv')
      end
    end

    context '#find_lat_lng' do
      it 'creates a Location object' do
        VCR.use_cassette('lat_lng_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
          mapquest_facade = MapquestFacade.new('lasvegas,nv')

          expect(mapquest_facade.find_lat_lng).to be_a(Location)
        end
      end
    end
  end
end