module Integrator
  class Paycheck < Nested
    attr_reader :id, :person_id, :personal_charge_id, :academic_unit_id, :month, :data
    
    def to_s
      "#{month} - #{person}"
    end

    def person
      Person.find(person_id)
    end
    
    def academic_unit
      AcademicUnit.find(academic_unit_id)
    end
  end
end
