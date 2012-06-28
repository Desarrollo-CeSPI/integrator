module Integrator
  class Degree < Nested
    attr_reader :id, :academic_unit_id, :code, :name, :female_name, :academic_unit_degree_type_id, :araucano_code
    
    def to_s
      "#{name}/#{female_name}"
    end
    
    def academic_unit
      AcademicUnit.find(academic_unit_id)
    end
    
    def academic_unit_degree_type
      AcademicUnitDegree.find(academic_unit_degree_type_id)
    end
    
    def career_programme_degrees
      response = Client.get subject: [academic_unit, self, CareerProgrammeDegree]
      
      response.collect { |item| CareerSubject.new(item) }
    end
  end
end
