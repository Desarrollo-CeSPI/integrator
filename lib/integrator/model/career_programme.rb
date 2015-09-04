module Integrator
  class CareerProgramme < Nested
    attr_reader :id, :career_id, :academic_unit_id, :programme, :year_count, :start_date, :total_subjects_count
    
    def to_s
      programme
    end

    def academic_unit
      @_academic_unit ||= AcademicUnit.find(academic_unit_id)
    end
    
    def career
      @_career ||= Career.find(career_id)
    end
    
    def career_subjects
      get_and_hydrate_collection CareerSubject, subject: [academic_unit, career, self, CareerSubject]
    end
    
    def career_programme_degrees
      get_and_hydrate_collection CareerProgrammeDegree, subject: [academic_unit, career, self, CareerProgrammeDegree]
    end
  end
end
