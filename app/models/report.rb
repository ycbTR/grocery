class Report < ApplicationRecord


  def self.generate_z_report
    ends_at = Time.now
    starts_at = Report.last.try(:ends_at) || Time.now.beginning_of_day

  end

end
