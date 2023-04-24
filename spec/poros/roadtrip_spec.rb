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

        lv_to_denver = Roadtrip.new({origin: 'las vegas,nv', destination: 'denver,co'}, roadtrip_data)

        expect(lv_to_denver).to be_a Roadtrip
        expect(lv_to_denver.start_city).to eq('las vegas,nv')
        expect(lv_to_denver.end_city).to eq('denver,co')
        expect(lv_to_denver.travel_time).to eq('10h32m')
      end
    end
  end
end