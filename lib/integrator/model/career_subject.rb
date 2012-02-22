module Integrator
  class CareerSubject < Nested
    attr_reader :id, :career_programme_id, :code, :name, :period, :type
    
    def career_programme
      CareerProgramme.find(career_programme_id)
    end
  end
end
