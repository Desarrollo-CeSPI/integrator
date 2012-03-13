module Integrator
  class Degree < Nested
    attr_reader :id, :academic_unit_id, :code, :name, :female_name, :academic_unit_degree_type_id
    
    def to_s
      name
    end
    
    def academic_unit
      AcademicUnit.find(academic_unit_id)
    end
    
    def academic_unit_degree_type
      AcademicUnitDegree.find(academic_unit_degree_type_id)
    end
  end
end
