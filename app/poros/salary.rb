# frozen_string_literal: true

# app/poros/salary.rb
class Salary
  attr_reader :title,
              :min,
              :max

  def initialize(data)
    @title = data[:job][:title]
    @min = data[:salary_percentiles][:percentile_25]
    @max = data[:salary_percentiles][:percentile_75]
  end
end
