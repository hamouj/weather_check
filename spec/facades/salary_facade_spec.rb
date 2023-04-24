require 'rails_helper'

describe SalaryFacade do
  describe 'instance methods' do
    before(:each) do
      @facade = SalaryFacade.new('las-vegas')
    end

    context '#initialize' do
      it 'exists' do
        expect(@facade).to be_a(SalaryFacade)
      end
    end

    context '#fetch_salaries' do
      it 'creates Salary objects for specific jobs' do
        VCR.use_cassette('lv_salaries', serialize_with: :json, allow_playback_repeats: true) do
          expect(@facade.fetch_salaries).to be_an Array
          expect(@facade.fetch_salaries.first).to be_a Salary
        end
      end
    end
  end
end