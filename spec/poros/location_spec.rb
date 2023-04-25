require 'rails_helper'

describe Location do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        las_vegas = Location.new({ lat: 36.17193, lng: -115.14001 })

        expect(las_vegas).to be_a Location
        expect(las_vegas.lat_lng).to eq('36.17193,-115.14001')
      end
    end
  end
end
