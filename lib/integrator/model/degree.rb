module Integrator
  class Degree < Nested
    attr_reader :id, :academic_unit_id, :code, :name, :female_name, :academic_unit_degree_type_id, :araucano_code
    
    def to_s
      "#{name}/#{female_name}"
    end
    
    def academic_unit
      @_academic_unit ||= AcademicUnit.find(academic_unit_id)
    end
    
    def academic_unit_degree_type
      @_academic_unit_degree_type ||= AcademicUnitDegree.find(academic_unit_degree_type_id)
    end
    
    def career_programme_degrees
      get_and_hydrate_collection CareerProgrammeDegree, subject: [academic_unit, self, CareerProgrammeDegree]
    end
  end
end
