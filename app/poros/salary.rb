# frozen_string_literal: true

# app/poros/salary.rb
class Salary
  attr_reader :title,
              :min,
              :max

  def initialize(data)
    @title = data[:job][:title]
    @min = format_money_amount(data[:salary_percentiles][:percentile_25])
    @max = format_money_amount(data[:salary_percentiles][:percentile_75])
  end

  private
    def format_money_amount(amount)
      amount.round(2).to_s
      .reverse
      .scan(/(\d*\.\d{1,3}|\d{1,3})/)
      .join(',')
      .reverse
      .insert(0, '$')
    end
end
