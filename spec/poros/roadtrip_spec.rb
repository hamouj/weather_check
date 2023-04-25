require 'rails_helper'

describe Roadtrip do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        roadtrip_data = {
          "route": {
            "sessionId": "AK0A5wcAAG4AAAAIAAAAFQAAAPUAAAB42mP4ysDAyMTAwMCekVqUapWc-1UyUBrIZbjWNMGNa26avJ7csx2RE4E0F5BmwAJgGkU5jcEaFUy272CwOhlmuqnIKQZEbwbSDDhA6DcryXZmkHWsDjwMCYwNAgwMDozY1bKACAFkESiHRYEBpEVCAspvAEIBBgcFByYGBwcg3xGil5FBgIWpSYVBhEnRiQEA18YiRj1zEJE:car",
            "realTime": 38624,
            "distance": 747.6798,
            "time": 37976,
            "formattedTime": "10:32:56"
          }
        }

        lv_to_denver = Roadtrip.new('las vegas,nv', 'denver,co', roadtrip_data)

        expect(lv_to_denver).to be_a Roadtrip
        expect(lv_to_denver.start_city).to eq('las vegas,nv')
        expect(lv_to_denver.end_city).to eq('denver,co')
        expect(lv_to_denver.travel_time).to eq('10h32m')
        expect(lv_to_denver.time).to eq('10:32:56')
      end
    end

    context '#format_travel_time()' do
      it 'formats travel time into days, hours, minutes' do
        roadtrip_data = {
          "route": {
            "distance": 747.6798,
            "time": 289919,
            "formattedTime": "80:31:59"
          }
        }

        ny_to_panama = Roadtrip.new('new york,ny', 'panama city,panama', roadtrip_data)

        expect(ny_to_panama.travel_time).to eq('3d8h31m')
      end
    end
  end
end
