module Integrator
  class PersonalCharge < Nested
    attr_accessor :id, :official_scale, :scale

    def to_s
      "#{scale}"
    end
  end
end
