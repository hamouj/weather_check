require 'rails_helper'

describe TeleportService do
  context 'class methods' do
    context '#get_salaries()' do
      it 'returns salary information for a destination' do
        VCR.use_cassette('lv_salaries', serialize_with: :json) do
          lv_salaries = TeleportService.get_salaries('las-vegas')

          expect(lv_salaries).to be_a Hash
          expect(lv_salaries).to have_key :salaries
          expect(lv_salaries[:salaries][16]).to have_key :job
          expect(lv_salaries[:salaries][16][:job]).to have_key :title
          expect(lv_salaries[:salaries][16][:job][:title]).to be_a String
          expect(lv_salaries[:salaries][16]).to have_key :salary_percentiles
          expect(lv_salaries[:salaries][16][:salary_percentiles]).to have_key :percentile_25
          expect(lv_salaries[:salaries][16][:salary_percentiles][:percentile_25]).to be_a Float
          expect(lv_salaries[:salaries][16][:salary_percentiles]).to have_key :percentile_75
          expect(lv_salaries[:salaries][16][:salary_percentiles][:percentile_75]).to be_a Float
        end
      end
    end
  end
end