module Integrator
  class CareerSubject < Nested
    attr_reader :id, :career_programme_id, :code, :name, :period, :type
    
    def to_s
      name
    end

    def career_programme
      @_career_programme ||= CareerProgramme.find(career_programme_id)
    end
  end
end
