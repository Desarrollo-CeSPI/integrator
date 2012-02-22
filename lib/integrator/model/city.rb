module Integrator
  class City < Nested
    attr_reader :id, :name, :department_id
    
    def department
      Department.find(department_id)
    end
  end
end
