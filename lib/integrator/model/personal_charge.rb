module Integrator
  class PersonalCharge < Base
    attr_reader :id, :official_scale, :scale

    def to_s
      "#{scale}"
    end
  end
end
