require 'rails_helper'

describe MapquestService do
  context 'class methods' do
    context '#get_lat_lng()' do
      it 'returns the latitude and longitude of a location' do
        VCR.use_cassette('lat_lng_lv', serialize_with: :json) do
          las_vegas = MapquestService.get_lat_lng('las vegas,nv')

          expect(las_vegas).to be_a Hash
          expect(las_vegas).to have_key :results
          expect(las_vegas[:results][0]).to have_key :locations
          expect(las_vegas[:results][0][:locations][0]).to have_key :latLng
          expect(las_vegas[:results][0][:locations][0][:latLng]).to have_key :lat
          expect(las_vegas[:results][0][:locations][0][:latLng][:lat]).to be_a Float
          expect(las_vegas[:results][0][:locations][0][:latLng]).to have_key :lng
          expect(las_vegas[:results][0][:locations][0][:latLng][:lng]).to be_a Float
        end
      end
    end
  end
end