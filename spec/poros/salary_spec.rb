require 'rails_helper'

describe Salary do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        data = {
          "job": {
              "id": "DATA-ANALYST",
              "title": "Data Analyst"
          },
          "salary_percentiles": {
              "percentile_25": 33945.35378253495,
              "percentile_50": 40853.61816680858,
              "percentile_75": 49167.79268266486
          }
      }

      data_analyst_salary = Salary.new(data)

      expect(data_analyst_salary).to be_a Salary
      expect(data_analyst_salary.title).to eq('Data Analyst')
      expect(data_analyst_salary.min).to eq(33945.35378253495)
      expect(data_analyst_salary.max).to eq(49167.79268266486)
      end 
    end
  end
end