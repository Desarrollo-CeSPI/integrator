module Integrator
  class Career < Nested
    attr_reader :id, :code, :name, :academic_unit_id, :created_at
    
    def to_s
      name
    end

    def academic_unit
      @_academic_unit ||= AcademicUnit.find(academic_unit_id)
    end
    
    def career_programmes
      get_and_hydrate_collection CareerProgramme, subject: [academic_unit, self, CareerProgramme]
    end
  end
end
