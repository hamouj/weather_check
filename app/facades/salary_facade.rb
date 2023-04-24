# frozen_string_literal: true

# app/facades/salary_facade.rb
class SalaryFacade
  def initialize(destination)
    @destination = destination
  end

  def fetch_salaries
    jobs = ["Data Analyst", "Data Scientist", "Mobile Developer", "QA Engineer", "Software Engineer", "Systems Administrator", "Web Developer"]
    data = TeleportService.get_salaries(@destination)

    job_data = data[:salaries].select do |salary|
      jobs.include?(salary[:job][:title])
    end

    job_data.map do |job|
      Salary.new(job)
    end
  end
end
