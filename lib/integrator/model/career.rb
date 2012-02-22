module Integrator
  class Career < Nested
    attr_reader :id, :code, :name, :academic_unit_id, :created_at
    
    def academic_unit
      AcademicUnit.find(academic_unit_id)
    end
    
    def career_programmes
      response = Client.get(subject: [academic_unit, self, CareerProgramme])
      
      response.collect do |item|
        CareerProgramme.new(item)
      end
    end
  end
end
