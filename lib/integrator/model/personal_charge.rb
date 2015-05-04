module Integrator
  class PersonalCharge < Base
    attr_reader :id, :official_scale, :scale, :starts_at, :ends_at

    def to_s
      "#{scale}"
    end

    def active?
      active_at? Date.today
    end

    def active_at?(date)
      starts_at.to_date <= date && (ends_at.nil? || ends_at.to_date >= date)
    end
  end
end
